--PRODUCT
CREATE TABLE Product_line(
	Product_line_code INTEGER NOT NULL,
	Product_line_en NVARCHAR(40) NOT NULL,
PRIMARY KEY(Product_line_code)
);

CREATE TABLE Product_type(
	Product_type_code INTEGER NOT NULL,
	Product_line_code INTEGER,
	Product_type_en INTEGER NOT NULL,
PRIMARY KEY(Product_type_code),
FOREIGN KEY Product_line_code REFERENCES Product_line
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

CREATE TABLE product(
	Product_number INTEGER NOT NULL,
	Introduction_date DATE NOT NULL,
	Product_type_code INTEGER NOT NULL,
	Production_cost FLOAT NOT NULL,
	Margin FLOAT NOT NULL,
	Product_image NVARCHAR(150) NOT NULL,
	Product_name NVARCHAR(255) NOT NULL,
PRIMARY KEY(Product_number),
FOREIGN KEY Product_type_code REFERENCES Product_type
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

--MEDEWERKERS
CREATE TABLE Sales_Branche(
	Sales_branche_code INTEGER NOT NULL,
	Address1 NVARCHAR(50) NOT NULL,
	Address2 NVARCHAR(50),
	City NVARCHAR(40),
	Region NVARCHAR(50),
	Postal_zone NVARCHAR(10),
	Country_code INTEGER NOT NULL,
PRIMARY KEY(Sales_branche_code),
FOREIGN KEY Country_code REFERENCES Country
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

CREATE TABLE Bonus(
	Bonus_id INTEGER NOT NULL,
	Werknemer_id INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Bedrag DOUBLE NOT NULL,
PRIMARY KEY(Bonus_id),
FOREIGN KEY Werknemer_id REFERENCES Werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

CREATE TABLE Sales_target(
	Werknemer_id INTEGER NOT NULL,
	Sales_year INTEGER NOT NULL,
	Sales_period INTEGER NOT NULL,
	Product_Number INTEGER NOT NULL,
	Sales_target FLOAT NOT NULL, 
	Retailer_code INTEGER NOT NULL,
PRIMARY KEY(Werknemer_id, Sales_year, Sales_period, Product_Number, Retailer_code),
FOREIGN KEY Werknemer_id REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Product_Number REFERENCES Product
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Retailer_code REFERENCES Retailer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

CREATE TABLE werknemer (
	Werknemer_id INTEGER NOT NULL,
	First_name NVARCHAR(25) NOT NULL,
	Last_name NVARCHAR(30) NOT NULL,
	Functie INTEGER NOT NULL,
	Work_phone NVARCHAR(20),
	Extension NVARCHAR(6),
	Fax NVARCHAR(20),
	Email NVARCHAR(50),
	Date_hired DATE NOT NULL,
	Sales_branche_code INTEGER NOT NULL,
	Afdeling INTEGER NOT NULL,
	Manager INTEGER,
	Max_korting_percentage DOUBLE,
	CV INTEGER NOT NULL,
	Salaris DOUBLE NOT NULL,
	Geboortedatum DATE NOT NULL,
	Datum_uit_dienst DATE,
	Prestatie_niveau INTEGER,
PRIMARY KEY(Werknemer_id),
FOREIGN KEY Functie REFERENCES Functie
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Sales_branche_code REFERENCES Sales_branche
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Afdeling REFERENCES Afdeling
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Manager REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY CV REFERENCES werknemer_cv
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Prestatie_niveau REFERENCES Prestatieniveau
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
CHECK(date_hired > Geboortedatum),
CHECK(date_hired < Datum_uit_dienst),
CHECK(Salaris >= 950)
);

--HRM
CREATE TABLE Werknemer_Prestatieniveau (
	Prestatieniveau _id INTEGER NOT NULL,
	Omschrijving VARCHAR(50) NOT NULL,
PRIMARY KEY(Prestatieniveau_id)
);

CREATE TABLE Werknemer_CV (
	Id INTEGER NOT NULL,
	Werkervaring VARCHAR(500) NULL,
	Opleidingen VARCHAR(500) NULL,
	Bijzonderheden VARCHAR(500) NULL,
PRIMARY KEY(Id)
);

CREATE TABLE Cursus(
	Cursus_id INTEGER NOT NULL,
	Naam VARCHAR(50) NOT NULL,
	Datum DATE NOT NULL,
PRIMARY KEY(Cursus_id)
);

CREATE TABLE Training(
	Training_id INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Werknemer_id INT NOT NULL,
	Course INT NOT NULL,
	Geslaagd BOOLEAN NOT NULL
PRIMARY KEY(Training_id),
FOREIGN KEY Werknemer_id REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Course REFERENCES Cursus
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

--ORDERS
CREATE TABLE Order_header(
	Order_Number INTEGER NOT NULL,
	Retailer_site_code INTEGER NOT NULL,
	Retailer_contact_code INTEGER NOT NULL,
	Werknemer_id INTEGER NOT NULL,
	Sales_branche_code INTEGER NOT NULL,
	Order_date DATE NOT NULL,
	Order_method_code INTEGER NOT NULL,
	Korting_percentage DOUBLE,
	Status INTEGER NOT NULL,
PRIMARY KEY(Order_Number),
FOREIGN KEY Retailer_site_code REFERENCES Retailer_site
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Werknemer_id REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Sales_branche_code REFERENCES Sales_brache
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Order_method_code REFERENCES Order_method
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Status REFERENCES Order_status
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
CHECK (Korting_percentage <= 8)
);

CREATE TABLE Order_details(
	Order_detail_code INTEGER NOT NULL,
	Order_number INTEGER NOT NULL,
	Product_number INTEGER NOT NULL,
	Quantity SMALLINT,
	Unit_cost FLOAT,
	Unit_price FLOAT,
	Unit_sale_price FLOAT,
PRIMARY KEY(Order_detail_code),
FOREIGN KEY Order_number REFERENCES Order_header
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Product_number REFERENCES product
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

--CUSTOMER
CREATE TABLE Klant(
	Klant_id INTEGER NOT NULL,
	Klant_naam VARCHAR(100) NOT NULL,
	Straat VARCHAR() NOT NULL,
	Huisnummer INTEGER NOT NULL, 
	Huisnummer_toev VARCHAR(10) NULL,
	Postcode VARCHAR(6) NOT NULL,
	Woonplaats VARCHAR(50) NOT NULL,
PRIMARY KEY(Klant_id)
);

CREATE TABLE Retailer (
	Retailer_code INTEGER NOT NULL,
	Retailer_codemr INTEGER,
	Company_Name NVARCHAR(50) NOT NULL,
	Retailer_type_code INTEGER NOT NULL,
PRIMARY KEY(Retailer_code),
FOREIGN KEY Retailer_type_code REFERENCES Retailer_type
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

--VOORRAAD EN LOGISTIEK
---HIER MISSSEN NOG GEGEVENS OVER DE LOGISTIEK!!!
CREATE TABLE Inventory_levels(
	Inventory_year SMALLINT NOT NULL,
	Inventory_month SMALLINT NOT NULL,
	Product_number INTEGER NOT NULL,
	Inventory_count INTEGER NOT NULL,
	Min_Voorraad INTEGER NOT NULL,
	Verwachte_levertijd INTEGER,
PRIMARY KEY(Inventory_year, Inventory_month, Product_number),
FOREIGN KEY Product_number REFERENCES product
	ON DELETE RESTRICT
	ON UPDATE RESTRICT
);

-------------
-------------
-------------

--STORED PROCEDURES

CREATE PROCEDURE controleerSalarisMetManager (Werknemer_Salaris IN FLOAT, Manager_id IN INTEGER, Salaris_OK OUT BOOLEAN)
AS
BEGIN
	DECLARE Manager_salaris FLOAT

	SELECT salaris INTO Manager_salaris 
	FROM werknemer 
	WHERE Werknemer_id = Manager_id
	
	IF Werknemer_Salaris < Manager_salaris --OK
		SELECT 1 INTO Salaris_OK
	ELSE --NIET OK
		SELECT 0 INTO Salaris_OK
END

CREATE PROCEDURE controleerBonusGehaald (Medewerker_id IN INTEGER, Jaar IN SMALLINT, Periode IN SMALLINT, Retailer IN INTEGER, vervolgactie OUT VARCHAR(20))
AS
BEGIN
	DECLARE aantalProductenNietGehaald INT
	DECLARE totaalLaatse6Bonussen DOUBLE

	SELECT 
		COUNT(Product_number) INTO aantalProductenNietGehaald
	FROM Sales_target ST
		INNER JOIN Order_details OD ON OH.Order_Number = OD.Order_Number
	WHERE Werknemer_id = Medewerker_id
		AND Sales_year = Jaar
		AND Sales_period = Periode
		AND Retailer_code = Retailer
		AND Product_number = OD.Product_number
		AND Sales_target <= SUM(OD.Quantity)
		
	IF aantalProductenNietGehaald = 0
	BEGIN
		INSERT 'wel_bonus' INTO vervolgactie
	END
	ELSE
	BEGIN
		SELECT SUM(TOP 6 Bedrag) INTO totaalLaatse6Bonussen FROM Bonus WHERE werknemer_id = Medewerker_id ORDER BY Datum DESC)
		
		IF totaalLaatse6Bonussen = 0
			SELECT 'salaris_korten' INTO vervolgactie
		ELSE
			SELECT 'geen_bonus' INTO vervolgactie
	END
END

CREATE PROCEDURE controleerTotaalBetalingen (Factuur_nummer IN INTEGER)
AS
BEGIN
	DECLARE totaalTeBetalen FLOAT
	DECLARE totaalBetaald FLOAT
	
	IF (SELECT  FROM Factuur F INNER JOIN Factuur_bron_type FBT ON F.Factuur_bron_type = FBT.id WHERE F.Factuur_id = Factuur_nummer) = "Order"
	BEGIN --ORDER
		SELECT 
			SUM(OD.Unit_sale_price * OD.Quantity) INTO totaalTeBetalen 
		FROM Order_details OD
			INNER JOIN Factuur F ON OD.Order_detail_code = F.Factuur_bron
		WHERE F.id = Factuur_id
	END
	ELSE
	BEGIN --BOEKING
		SELECT 
			B.Boekingbedrag INTO totaalTeBetalen 
		FROM Boeking B 
			INNER JOIN Factuur F ON B.Boeking_id = F.Factuur_bron 
		WHERE F.id = Factuur_id
	END
	
	SELECT SUM(B.Bedrag) INTO totaalBetaald
	FROM Betaling B 
	WHERE B.Factuur_id = Factuur_nummer
	
	IF totaalTeBetalen >= totaalBetaald
		--VERPLAATSEN NAAR ANDERE TABEL ???
END

-------------
-------------
-------------

CREATE TRIGGER spanOfControl
BEFORE INSERT ON werknemer
FOR EACH ROW
BEGIN
	DECLARE aantalMedewerkers INTEGER
	SELECT COUNT(*) INTO aantalMedewerkers FROM werknemers WHERE manager = new.werknemer_id
	
	IF aantalMedewerkers >= 12
		ROLLBACK
END

CREATE TRIGGER controleSalaris
BEFORE INSERT ON werknemer
FOR EACH ROW
BEGIN
	DECLARE minSalaris DOUBLE
	DECLARE maxSalaris DOUBLE
	
	SELECT salaris_min INTO minSalaris, salaris_max INTO maxSalaris FROM Functie WHERE Functie_id = new.Functie
	
	IF new.Salaris < minSalaris OR new.Salaris > maxSalaris
		ROLLBACK
END
