--VERSIE 0.4

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
	ON UPDATE CASCADE
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
	ON UPDATE CASCADE
);

CREATE TABLE Sales_Branche(
	Sales_branche_code INTEGER NOT NULL,
	Address1 NVARCHAR(50) NOT NULL,
	Address2 NVARCHAR(50),
	City NVARCHAR(40),
	Region NVARCHAR(50),
	Postal_zone NVARCHAR(10),
	Country_code INTEGER NOT NULL,
PRIMARY KEY(Sales_branche_code),
);

CREATE TABLE Werknemer_CV (
	Id INTEGER NOT NULL,
	Werkervaring VARCHAR(500) NULL,
	Opleidingen VARCHAR(500) NULL,
	Bijzonderheden VARCHAR(500) NULL,
PRIMARY KEY(Id)
);

CREATE TABLE Werknemer_Prestatieniveau (
	Prestatieniveau_id INTEGER NOT NULL,
	Omschrijving VARCHAR(50) NOT NULL,
PRIMARY KEY(Prestatieniveau_id)
);

CREATE TABLE Afdeling (
	Afdeling_id INTEGER NOT NULL,
	Omschrijving VARCHAR(50) NOT NULL,
	Manager INTEGER NOT NULL,
PRIMARY KEY(Afdeling_id)
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
FOREIGN KEY Sales_branche_code REFERENCES Sales_branche
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY Manager REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY CV REFERENCES werknemer_cv
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY Prestatie_niveau REFERENCES Werknemer_Prestatieniveau
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY Afdeling REFERENCES Afdeling
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
CHECK(date_hired > Geboortedatum),
CHECK(date_hired < Datum_uit_dienst),
CHECK(Salaris >= 950)
);

ALTER TABLE Afdeling
	ADD FOREIGN KEY(Manager) REFERENCES Medewerker
	ON DELETE RESTRICT,
	ON UPDATE CASCADE;

CREATE TABLE Functioneringsgesprek (
	Id INTEGER NOT NULL,
	Werknemer INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Opmerking VARCHAR(500),
PRIMARY KEY(Id),
FOREIGN KEY Werknemer REFERENCES Werknemer
	ON DELETE DELETE
	ON UPDATE CASCADE
);

CREATE TABLE Bonus(
	Bonus_id INTEGER NOT NULL,
	Werknemer_id INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Bedrag DOUBLE NOT NULL,
PRIMARY KEY(Bonus_id),
FOREIGN KEY Werknemer_id REFERENCES Werknemer
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Klant(
	Klant_id INTEGER NOT NULL,
	klant_codemr INTEGER,
	Naam NVARCHAR(50) NOT NULL,
	Klant_type INTEGER NOT NULL,
PRIMARY KEY(Klant_id)
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
	ON UPDATE RESTRICT, --Deel van PK
FOREIGN KEY Product_Number REFERENCES Product
	ON DELETE RESTRICT
	ON UPDATE RESTRICT, --Deel van PK
FOREIGN KEY Retailer_code REFERENCES Klant
	ON DELETE RESTRICT
	ON UPDATE RESTRICT --Deel van PK
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
	ON UPDATE CASCADE,
FOREIGN KEY Course REFERENCES Cursus
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

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
FOREIGN KEY Werknemer_id REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
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
	ON UPDATE CASCADE,
FOREIGN KEY Product_number REFERENCES product
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE Magazijn (
	Id INTEGER NOT NULL,
	Locatie VARCHAR(50) NOT NULL,
PRIMARY KEY(Id)
);

CREATE TABLE Inventory_levels(
	Inventory_year SMALLINT NOT NULL,
	Inventory_month SMALLINT NOT NULL,
	Product_number INTEGER NOT NULL,
	Magazijn INTEGER NOT NULL,
	Inventory_count INTEGER NOT NULL,
	Verwachte_levertijd INTEGER,
PRIMARY KEY(Inventory_year, Inventory_month, Product_number, Magazijn),
FOREIGN KEY Product_number REFERENCES product
	ON DELETE RESTRICT
	ON UPDATE RESTRICT, --Deel van PK
FOREIGN KEY Magazijn REFERENCES Magazijn
	ON DELETE RESTRICT
	ON UPDATE RESTRICT, --Deel van PK
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
	DECLARE orderNumber INT
	
	IF EXISTS(SELECT * FROM Factuur F INNER JOIN Factuur_bron_type FBT ON F.Factuur_bron_type = FBT.id WHERE F.Factuur_id = Factuur_nummer) = "Order"
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
	
	IF totaalTeBetalen >= totaalBetaald AND EXISTS(SELECT * FROM Factuur F INNER JOIN Factuur_bron_type FBT ON F.Factuur_bron_type = FBT.id WHERE F.Factuur_id = Factuur_nummer) = "Order"
	BEGIN
		SELECT F.Factuur_bron INTO orderNumber FROM Factuur F WHERE F.id = Factuur_id
		
		INSERT INTO Order_details_Verwerkt
		SELECT * FROM Order_details WHERE Order_number = orderNumber
		
		INSERT INTO Order_header_verwerkt
		SELECT * FROM Order_header WHERE Order_number = orderNumber
		
		DELETE FROM Order_details_Verwerkt WHERE Order_number = orderNumber
		DELETE FROM Order_header_verwerkt WHERE Order_number = orderNumber
	END
END

-------------
-------------
-------------

CREATE TRIGGER spanOfControl
BEFORE INSERT ON werknemer
FOR EACH ROW
BEGIN
	DECLARE aantalMedewerkers INTEGER
	SELECT COUNT(*) INTO aantalMedewerkers FROM werknemers WHERE manager = new.manager
	
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
