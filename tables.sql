
======================================================================================================================================================================================================
---------------------------------------------------------------------------------------------------TABLE CREATION-------------------------------------------------------------------------------------
=======================================================================================================================================================================================================

CREATE TABLE Location

 (

 pincode numeric(6) PRIMARY KEY,

 area varchar(30) NOT NULL,

 city varchar(20) NOT NULL,

 state varchar(20) NOT NULL

 );


 CREATE TABLE Inventory

 (

 I_id int PRIMARY KEY,

 I_name varchar(100) NOT NULL,

 I_contactno numeric(10),

 I_address numeric(6) NOT NULL,

 FOREIGN KEY (I_address) REFERENCES Location(pincode)

 );

 CREATE TABLE Vaccine

 (

 V_name varchar(20) PRIMARY KEY,

 V_company varchar(20) NOT NULL,

 V_cost float NOT NULL

 );


 CREATE TABLE Hospital

 (

 H_id int PRIMARY KEY,

 H_name varchar(30) NOT NULL,

 H_pwd varchar(200),

 H_contactno numeric(10),

 H_address numeric(6) NOT NULL,

 H_email varchar(30),

 H_vac varchar(20),

 FOREIGN KEY (H_address) REFERENCES Location(pincode) ,

 FOREIGN KEY (H_vac) REFERENCES Vaccine(V_name)

 );

CREATE TABLE Supplies

 (

 S_id int primary key,

 S_hospital int,

 S_inventory int ,

 S_quantity numeric,

 Foreign key (S_hospital) references hospital(h_id) ,

 Foreign key (S_inventory) references inventory(i_id)

 );


 CREATE TABLE Person

 (

 P_id int PRIMARY KEY ,

 P_name varchar(30) NOT NULL,

 P_Gender char(20) NOT NULL,

 P_DOB DATE NOT NULL,

 P_contactno numeric(10),

 P_address numeric(6),

 P_email varchar(30),

 FOREIGN KEY (P_address) REFERENCES Location(pincode)

 );



 CREATE TABLE Doctor

 (

 D_id int PRIMARY KEY,

 D_dept varchar(20) NOT NULL,

 FOREIGN KEY (D_id) REFERENCES Person(P_id)

 );


 CREATE TABLE Vaccinates

 (

 P int,

 Hosp int,

 Date_first DATE,

 Date_second DATE,

 PRIMARY KEY (P, Hosp),

 FOREIGN KEY (P) REFERENCES Person(P_id) ,

 FOREIGN KEY (Hosp) REFERENCES Hospital(H_id)

 );


==================================================================================================================================================================================================
----------------------------------------------------------------------------------INSERT VALUES---------------------------------------------------------------------------------------------------
==================================================================================================================================================================================================

INSERT INTO Location VALUES('400029', 'Andheri', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400051', 'Bandra East', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400050', 'Bandra West', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400069', 'Andheri East', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400091', 'Borivali', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400014', 'Dadar', 'Mumbai', 'Maharashtra');
INSERT INTO Location VALUES('400500', 'Chalthan', 'Surat', 'Gujarat');

INSERT INTO Inventory VALUES('1', 'Lilavati Hospital And Research Centre', '7789234121', '400050');
INSERT INTO Inventory VALUES('2', 'S L Raheja Fortis Hospital', '8056379544', '400051');
INSERT INTO Inventory VALUES('3', 'Sanghvi Hospital', '8989882310' , '400029');

INSERT INTO Vaccine VALUES('Covaxin', 'Bharat Biotech', '3500');
INSERT INTO Vaccine VALUES('Covishield', 'AstraZeneca', '3000');
INSERT INTO Vaccine VALUES ('Sputnik','Gamaleya Center','1000');

INSERT INTO Hospital VALUES('1','Lilavati Hospital',NULL,'7789234121','400051',NULL,'Covaxin');
INSERT INTO Hospital VALUES('2','S L R Hospital',NULL,'8056379544','400051',NULL,'Covishield');
INSERT INTO Hospital VALUES('3','Seven Hills Hospital', NULL , '8989898456','400029',NULL,'Covaxin');
INSERT INTO Hospital VALUES('4','Phoenix Hospitals', NULL , '8934561245','400091',NULL,'Covaxin');
INSERT INTO Hospital VALUES('5','Shushrusha Citizens Hospital', NULL , '9999944454','400014',NULL,'Sputnik');
INSERT INTO Hospital VALUES('6','Apollo City Hospital', NULL , '9998744454','400500',NULL,'Covishield');

INSERT INTO Supplies VALUES('101','2','1','5000');
INSERT INTO Supplies VALUES('153','5','3','10110');
INSERT INTO Supplies VALUES('213','4','2','8000');
INSERT INTO Supplies VALUES('41','1','1','515');
INSERT INTO Supplies VALUES('36','3','3','3200');
INSERT INTO Supplies VALUES('107','6','2','1200');

INSERT INTO Person VALUES('1','Sarita Sen','female','12-MAR-1992','7845461233','400051',NULL);
INSERT INTO Person VALUES('45','Rahul Garg','male','05-NOV-1985','8565461213','400069',NULL);
INSERT INTO Person VALUES('23','Piya Soni','female','15-MAY-2005','7964313213','400014',NULL);
INSERT INTO Person VALUES('203','Mina Malhotra','female','27-DEC-1998','7821985485','400091',NULL);
INSERT INTO Person VALUES('78','Andrew Dsouza','male','04-AUG-1973','8564652344','400050',NULL);

INSERT INTO Doctor VALUES('1','A');
INSERT INTO Doctor VALUES('45','B');
INSERT INTO Doctor VALUES('23','C');
INSERT INTO Doctor VALUES('203','D');
INSERT INTO Doctor VALUES('78','A');

INSERT INTO Vaccinates VALUES('23','1','15-AUG-2020','13-DEC-2020');
INSERT INTO Vaccinates VALUES('203','2','15-JAN-2021','23-APR-2021');
INSERT INTO Vaccinates VALUES('45','3','09-OCT-2020','10-FEB-2021');
INSERT INTO Vaccinates VALUES('1','4','10-MAY-2021','14-AUG-2021');
INSERT INTO Vaccinates VALUES('78','5','06-DEC-2020','08-APR-2021');


==============================================================================================================================================================================================================
----------------------------------------------------------------------------------------------TRIGGERS AND PL/SQL BLOCKS--------------------------------------------------------------------------------------
===============================================================================================================================================================================================================

// number of vaccine supplied to a particular hospital//
    
CREATE OR REPLACE FUNCTION GetTotalVaccinationsForHospital(hospital_id IN NUMBER)
RETURN NUMBER IS
   total_vaccinations NUMBER;
BEGIN
   SELECT SUM(S_quantity) INTO total_vaccinations
   FROM Supplies
   WHERE S_hospital = hospital_id;

   RETURN total_vaccinations;
END GetTotalVaccinationsForHospital;
/

// allows a hospital to update its contact information //

CREATE OR REPLACE PROCEDURE UpdateHospitalContactInfo(
    hospital_id IN NUMBER,
    new_contactno IN NUMBER,
    new_email IN VARCHAR2
) IS
BEGIN
    UPDATE Hospital
    SET H_contactno = new_contactno, H_email = new_email
    WHERE H_id = hospital_id;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Hospital contact information updated successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Hospital not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END UpdateHospitalContactInfo;
/

BEGIN
    UpdateHospitalContactInfo(2, 1234567890, 'newemail@example.com');
END;
/

// PL/SQL block to calculate the total cost of vaccines for a hospital //
DECLARE
  v_HospitalID INT := 1; -- Specify the hospital ID for which you want to calculate the cost
  v_TotalCost FLOAT := 0;
BEGIN
  -- Calculate the total cost of vaccines for the specified hospital
  SELECT SUM(V.V_cost)
  INTO v_TotalCost
  FROM Hospital H
  JOIN Vaccine V ON H.H_vac = V.V_name
  WHERE H.H_id = v_HospitalID;

  -- Display the result
  DBMS_OUTPUT.PUT_LINE('Total cost of vaccines for Hospital ' || v_HospitalID || ' is $' || v_TotalCost);
END;
/

// PL/SQL query to retrieve doctor information for a specific hospital //
DECLARE
  v_HospitalName VARCHAR2(30) := 'Lilavati Hospital'; -- Specify the hospital name
BEGIN
  -- Display header
  DBMS_OUTPUT.PUT_LINE('Doctors at ' || v_HospitalName || ':');
  
  -- Query to retrieve doctor names and contact numbers
  FOR dr IN (SELECT P.P_name, P.P_contactno
             FROM Doctor D
             JOIN Person P ON D.D_id = P.P_id
             JOIN Hospital H ON P.P_address = H.H_address
             WHERE H.H_name = v_HospitalName)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Name: ' || dr.P_name || ', Contact Number: ' || dr.P_contactno);
  END LOOP;
END;
/

// PL/SQL query to retrieve hospital names and the number of vaccines supplied //
DECLARE
  CURSOR HospitalSuppliesCursor IS
    SELECT H.H_name, SUM(S.S_quantity) AS TotalVaccinesSupplied
    FROM Hospital H
    JOIN Supplies S ON H.H_id = S.S_hospital
    GROUP BY H.H_name;
BEGIN
  -- Display header
  DBMS_OUTPUT.PUT_LINE('Hospital Name | Total Vaccines Supplied');
  DBMS_OUTPUT.PUT_LINE('---------------------------------');
  
  -- Query to retrieve hospital names and the number of vaccines supplied
  FOR HospitalRecord IN HospitalSuppliesCursor
  LOOP
    DBMS_OUTPUT.PUT_LINE(HospitalRecord.H_name || ' | ' || HospitalRecord.TotalVaccinesSupplied);
  END LOOP;
END;
/

Q. Number of patients whose age is above 40 
DECLARE
  v_count NUMBER := 0;
  v_age NUMBER;
BEGIN
  FOR patient_rec IN (SELECT P_id, P_DOB FROM Person) LOOP
    -- Calculate age based on date of birth
    v_age := EXTRACT(YEAR FROM sysdate) - EXTRACT(YEAR FROM patient_rec.P_DOB);
    IF v_age > 40 THEN
      v_count := v_count + 1;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Number of patients above 40 years old: ' || v_count);
END;
/

Q. Which vaccine was given to the maximum patients?
DECLARE
  v_vaccine_name VARCHAR(20);
  v_max_supplies NUMBER := 0;
BEGIN
  FOR vaccine_rec IN (
    SELECT H_vac, COUNT(*) AS TotalSupplies
    FROM Hospital
    GROUP BY H_vac
    ORDER BY COUNT(*) DESC
  )
  LOOP
    IF vaccine_rec.TotalSupplies > v_max_supplies THEN
      v_max_supplies := vaccine_rec.TotalSupplies;
      v_vaccine_name := vaccine_rec.H_vac;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('The vaccine supplied the most in hospitals is ' || v_vaccine_name || ' with ' || v_max_supplies || ' supplies.');
END;
/

Q. Name of city with least vaccines?
DECLARE
  v_city_name VARCHAR(30);
  v_min_supplies NUMBER := NULL;
BEGIN
  FOR city_rec IN (
    SELECT l.city, SUM(s.S_quantity) AS TotalSupplies
    FROM Location l
    LEFT JOIN Hospital h ON l.pincode = h.H_address
    LEFT JOIN Supplies s ON h.H_id = s.S_hospital
    GROUP BY l.city
    ORDER BY SUM(s.S_quantity) ASC
  )
  LOOP
    IF v_min_supplies IS NULL OR city_rec.TotalSupplies < v_min_supplies THEN
      v_min_supplies := city_rec.TotalSupplies;
      v_city_name := city_rec.city;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('The city with the least vaccine is ' || v_city_name || ' with a total supply of ' || v_min_supplies || ' vaccines.');
END;
/

Q. Counts of covaxin in Mumbai city?
DECLARE
  v_mumbai_vaccines NUMBER;
BEGIN
  SELECT SUM(s.S_quantity)
  INTO v_mumbai_vaccines
  FROM Location l
  JOIN Hospital h ON l.pincode = h.H_address
  JOIN Supplies s ON h.H_id = s.S_hospital
  WHERE l.city = 'Mumbai';

  DBMS_OUTPUT.PUT_LINE('The total vaccines administered in Mumbai city is ' || v_mumbai_vaccines);
END;
/


