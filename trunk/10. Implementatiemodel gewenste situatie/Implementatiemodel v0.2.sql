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
	Position_en NVARCHAR(xxx) NOT NULL,			-----FOUT TYPE, MOET INTEGER ZIJN!!!!!
	Work_phone NVARCHAR(20),
	Extension NVARCHAR(6),
	Fax NVARCHAR(20),
	Email NVARCHAR(50),
	Date_hired DATE NOT NULL,
	Sales_branche_code INTEGER NOT NULL,
	Manager INTEGER,
	Max_korting_percentage DOUBLE,
	CV BLOB NOT NULL,
	Salaris DOUBLE NOT NULL,
	Geboortedatum DATE NOT NULL,
	Datum_uit_dienst DATE,
PRIMARY KEY(Werknemer_id),
FOREIGN KEY Position_en REFERENCES Functie
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY Sales_branche_code REFERENCES Sales_branche
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
FOREIGN KEY werknemer REFERENCES werknemer
	ON DELETE RESTRICT
	ON UPDATE RESTRICT,
CHECK(date_hired > Geboortedatum),
CHECK(date_hired < Datum_uit_dienst),
CHECK(Salaris >= 950)
);

--HRM
------------------HIER MIST NOT EEN TABEL MET DE FUNCTIONERINGSGESPREKKEN!!
------------------EN DE CV's
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
FOREIGN KEY Retailer_contact_code REFERENCES ????????????????????????? --WELKE TABEL???
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
	Huisnummer INTEGER NOT NULL, --------FOUT TYPE, MOET VARCHAR ZIJN, BV. 110a... Misschien beter een veld Adres maken met straat en huisnummer ineen.
	Postcode VARCHAR(6) NOT NULL,
	Woonplaats VARCHAR(50) NOT NULL -----------MISSCHIEN EEN VELD COUNTRY TOEVOEGEN????? FK NAAR COUNTRY
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

CREATE PROCEDURE controleerBonusGehaald (Medewerker_id IN INTEGER, Jaar IN SMALLINT, Periode IN SMALLINT, Retailer IN INTEGER)
AS
BEGIN
	DECLARE aantalProductenNietGehaald INT

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
		INSERT INTO 
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
		--VERPLAATSEN NAAR ANDERE TABEL OFZO????
END

-------------
-------------
-------------

NOG NIET INGEDEELD
?	Iedere unit heeft een manager.
?	Voorraad moet bijgewerkt worden bij een bestelling. Indien de voorraad beneden een bepaalde waarde komt, per producttype bestaat een maximum 1 t/m 10 500; 11 t/m 21 750), moet een melding komen dat er besteld moet worden.
?	Volgorde in status bestelling is dwingend (op transport komt na in magazijn bijvoorbeeld)

TRIGGER
?	Een manager (bijvoorbeeld van de salesstaff, de werknemers), heeft een span of control van 12. Bij toevoegen van een werknemer moet hierop gecontroleerd worden, manager moet uiteraard als functie manager hebben.
?	Salarissen moeten in overeenstemming zijn met de functies.
?	Bij sommige klanten (customers) staat aangegeven dat zij slechts een maximaal aantal producten mogen afnemen. Hierop moet gecontroleerd worden.
?	De verkoopmedewerkers (Sales representatives) mogen alleen klanten (customers of retailers) in hun eigen regio vertegenwoordigen. Dit geldt ook voor de employees van A&C. Bij toevoegen van een order moet hierop gecontroleerd worden.

CONSTRAINTS:
OK ?	Er mag maximaal 8% korting gegeven worden.
OK ?	Salaris mag nooit lager zijn dan het wettelijk minimumloon.
?	Datum moet in alle gevallen correct zijn, datum in dienst na geboortedatum, datum ontslag na datum in dienst, datum verzenden order na datum bestelling etc.

STORED PROCEDURE
OK ?	Een medewerker mag niet meer verdienen dan zijn manager
?	Indien een medewerker zijn target niet haalt, wordt er geen bonus gegeven. 
		Als de target 6 keer niet gehaald wordt, wordt er gekort op het salaris.
OK ?	Orders die geheel verwerkt zijn worden apart opgeslagen.