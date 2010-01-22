--VERSIE 0.4

/*
Script is gemaakt voor SQL Server 2008 
De foreign keys zijn automatisch restricted t.o.v. primary keys
*/

--OK
CREATE TABLE Product_line(
	Product_line_code INTEGER NOT NULL,
	Product_line_en NVARCHAR(40) NOT NULL,
PRIMARY KEY(Product_line_code)
);
--OK
CREATE TABLE Product_type(
	Product_type_code INTEGER NOT NULL,
	Product_line_code INTEGER,
	Product_type_en INTEGER NOT NULL,
PRIMARY KEY(Product_type_code),
CONSTRAINT fk_pl FOREIGN KEY (Product_line_code) REFERENCES Product_line
ON UPDATE CASCADE
);

--OK
CREATE TABLE product(
	Product_number INTEGER NOT NULL,
	Introduction_date DATE NOT NULL,
	Product_type_code INTEGER NOT NULL,
	Production_cost FLOAT NOT NULL,
	Margin FLOAT NOT NULL,
	Product_image NVARCHAR(150) NOT NULL,
	Product_name NVARCHAR(255) NOT NULL,
PRIMARY KEY(Product_number),
CONSTRAINT fk_pt FOREIGN KEY (Product_type_code) REFERENCES Product_type
	ON UPDATE CASCADE
);

--OK
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

--OK
CREATE TABLE Werknemer_CV (
	Id INTEGER NOT NULL IDENTITY(1,1),
	Werkervaring VARCHAR(500) NULL,
	Opleidingen VARCHAR(500) NULL,
	Bijzonderheden VARCHAR(500) NULL,
PRIMARY KEY(Id)
);

--OK
CREATE TABLE Werknemer_Prestatieniveau (
	Prestatieniveau_id INTEGER NOT NULL IDENTITY(1,1),
	Omschrijving VARCHAR(50) NOT NULL,
PRIMARY KEY(Prestatieniveau_id)
);

--OK
CREATE TABLE Afdeling (
	Afdeling_id INTEGER NOT NULL IDENTITY(1,1),
	Omschrijving VARCHAR(50) NOT NULL,
	Manager INTEGER NOT NULL,
PRIMARY KEY(Afdeling_id)
);

--OK
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
	Max_korting_percentage DECIMAL(19,2),
	CV INTEGER NOT NULL,
	Salaris DECIMAL(19,2) NOT NULL,
	Geboortedatum DATE NOT NULL,
	Datum_uit_dienst DATE,
	Prestatie_niveau INTEGER,
PRIMARY KEY(Werknemer_id),
CONSTRAINT fk_sb FOREIGN KEY (Sales_branche_code) REFERENCES Sales_branche
	ON UPDATE CASCADE,
CONSTRAINT fk_m FOREIGN KEY (Manager) REFERENCES werknemer,
	--Hier kan geen onupdate cascade, omdat er dan een kruisverwijzing gemaakt kan worden...
CONSTRAINT fk_cv FOREIGN KEY (CV) REFERENCES werknemer_cv
	ON UPDATE CASCADE,
CONSTRAINT fk_pn FOREIGN KEY (Prestatie_niveau) REFERENCES Werknemer_Prestatieniveau
	ON UPDATE CASCADE,
CONSTRAINT fn_a FOREIGN KEY (Afdeling) REFERENCES Afdeling
	ON UPDATE CASCADE,
CHECK(date_hired > Geboortedatum),
CHECK(date_hired < Datum_uit_dienst),
CHECK(Salaris >= 950),
CHECK(Max_korting_percentage <= 8)
);

--OK
ALTER TABLE Afdeling
	ADD CONSTRAINT fk_man FOREIGN KEY(Manager) REFERENCES Werknemer;
--Hier kan geen onupdate cascade, omdat er dan een kruisverwijzing gemaakt kan worden...

--OK
CREATE TABLE Functioneringsgesprek (
	Id INTEGER NOT NULL IDENTITY(1,1),
	Werknemer INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Opmerking VARCHAR(500),
PRIMARY KEY(Id),
CONSTRAINT fk_w FOREIGN KEY (Werknemer) REFERENCES Werknemer
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

--OK
CREATE TABLE Bonus(
	Bonus_id INTEGER NOT NULL IDENTITY(1,1),
	Werknemer_id INTEGER NOT NULL,
	Datum DATE NOT NULL,
	Bedrag DECIMAL(19,2) NOT NULL,
PRIMARY KEY(Bonus_id),
CONSTRAINT fk_wn FOREIGN KEY (Werknemer_id) REFERENCES Werknemer
	ON UPDATE CASCADE
);

--OK
CREATE TABLE Klant(
	Klant_id INTEGER NOT NULL,
	klant_codemr INTEGER,
	Naam NVARCHAR(50) NOT NULL,
	Klant_type INTEGER NOT NULL,
PRIMARY KEY(Klant_id)
);

--OK
CREATE TABLE Sales_target(
	Werknemer_id INTEGER NOT NULL,
	Sales_year INTEGER NOT NULL,
	Sales_period INTEGER NOT NULL,
	Product_Number INTEGER NOT NULL,
	Sales_target FLOAT NOT NULL, 
	Retailer_code INTEGER NOT NULL,
PRIMARY KEY(Werknemer_id, Sales_year, Sales_period, Product_Number, Retailer_code),
CONSTRAINT fk_wnr FOREIGN KEY (Werknemer_id) REFERENCES werknemer
	ON DELETE CASCADE, --Deel van PK
CONSTRAINT fk_pnr FOREIGN KEY (Product_Number) REFERENCES Product
	ON DELETE CASCADE, --Deel van PK
CONSTRAINT fk_rc FOREIGN KEY (Retailer_code) REFERENCES Klant
	ON DELETE CASCADE --Deel van PK
);

--OK
CREATE TABLE Cursus(
	Cursus_id INTEGER NOT NULL IDENTITY(1,1),
	Naam VARCHAR(50) NOT NULL,
	Datum DATE NOT NULL,
PRIMARY KEY(Cursus_id)
);

--OK
CREATE TABLE Training(
	Training_id INTEGER NOT NULL IDENTITY(1,1),
	Datum DATE NOT NULL,
	Werknemer_id INT NOT NULL,
	Course INT NOT NULL,
	Geslaagd BIT NOT NULL
PRIMARY KEY(Training_id),
CONSTRAINT fk_wnrid FOREIGN KEY (Werknemer_id) REFERENCES werknemer
	ON UPDATE CASCADE,
CONSTRAINT fk_c FOREIGN KEY (Course) REFERENCES Cursus
	ON UPDATE CASCADE
);

--OK
CREATE TABLE Order_header(
	Order_Number INTEGER NOT NULL,
	Retailer_site_code INTEGER NOT NULL,
	Retailer_contact_code INTEGER NOT NULL,
	Werknemer_id INTEGER NOT NULL,
	Sales_branche_code INTEGER NOT NULL,
	Order_date DATE NOT NULL,
	Order_method_code INTEGER NOT NULL,
	Korting_percentage DECIMAL(19,2),
	[Status	] INTEGER NOT NULL,
PRIMARY KEY(Order_Number),
CONSTRAINT fk_wnid2 FOREIGN KEY (Werknemer_id) REFERENCES werknemer
	ON UPDATE CASCADE,
CHECK (Korting_percentage <= 8)
);

--OK
CREATE TABLE Order_details(
	Order_detail_code INTEGER NOT NULL,
	Order_number INTEGER NOT NULL,
	Product_number INTEGER NOT NULL,
	Quantity SMALLINT,
	Unit_cost FLOAT,
	Unit_price FLOAT,
	Unit_sale_price FLOAT,
PRIMARY KEY(Order_detail_code),
CONSTRAINT fk_on FOREIGN KEY (Order_number) REFERENCES Order_header
	ON UPDATE CASCADE,
CONSTRAINT fk_pnr2 FOREIGN KEY (Product_number) REFERENCES product
	ON UPDATE CASCADE
);

--OK
CREATE TABLE Magazijn (
	Id INTEGER NOT NULL,
	Locatie VARCHAR(50) NOT NULL,
PRIMARY KEY(Id)
);

--OK
CREATE TABLE Inventory_levels (
	Inventory_year SMALLINT NOT NULL,
	Inventory_month SMALLINT NOT NULL,
	Product_number INTEGER NOT NULL,
	Magazijn INTEGER NOT NULL,
	Inventory_count INTEGER NOT NULL,
	Verwachte_levertijd INTEGER,
PRIMARY KEY(Inventory_year, Inventory_month, Product_number, Magazijn),
CONSTRAINT fk_pnr3 FOREIGN KEY (Product_number) REFERENCES product,
CONSTRAINT fk_mg FOREIGN KEY (Magazijn) REFERENCES Magazijn
);

-------------
-------------
-------------

--STORED PROCEDURES

GO

--OK
CREATE PROCEDURE controleerSalarisMetManager (@Werknemer_Salaris FLOAT, @Manager_id INTEGER, @Salaris_OK BIT OUT)
AS
BEGIN
	DECLARE @Manager_salaris FLOAT

	--Salaris van de manager ophalen
	SELECT @Manager_salaris = salaris 
	FROM werknemer 
	WHERE Werknemer_id = @Manager_id
	
	--Salaris kleiner dan salaris van manager, dan OK
	IF @Werknemer_Salaris < @Manager_salaris --OK
		SET @Salaris_OK = 1
	ELSE --NIET OK
		SET @Salaris_OK = 0
END

GO

--OK
CREATE PROCEDURE controleerBonusGehaald (@Medewerker_id INTEGER, @Jaar SMALLINT, @Periode SMALLINT, @Retailer INTEGER, @vervolgactie VARCHAR(20) OUT)
AS
BEGIN
	DECLARE @aantalProductenNietGehaald INT
	DECLARE @totaalLaatse6Bonussen DECIMAL(19,2)

	--Controleer voor welke producten de target voor deze periode niet gehaald is.
	SELECT 
		@aantalProductenNietGehaald = COUNT(OD.Product_number)
	FROM Sales_target ST
		INNER JOIN Order_details OD 
		ON OD.Product_number = ST.Product_Number
		INNER JOIN Order_header OH
		ON OH.Order_Number = OD.Order_Number
	WHERE ST.Werknemer_id = @Medewerker_id
		AND ST.Sales_year = @Jaar
		AND ST.Sales_period = @Periode
		AND ST.Retailer_code = @Retailer
		AND OH.Werknemer_id = @Medewerker_id
		AND YEAR(OH.Order_date) = @Jaar
		AND MONTH(OH.Order_date) = @Periode
	GROUP BY OD.Product_number, ST.Sales_target
	HAVING ST.Sales_target <= SUM(OD.Quantity)
		
	--Wanneer de target is gehaald, dan wel een bonus geven
	IF @aantalProductenNietGehaald = 0
	BEGIN
		SELECT @vervolgactie = 'wel_bonus'
	END
	ELSE
	BEGIN
		--Als er geen bonus is gegeven, dan is er WEL een entry met bedrag = 0
		
		--Tel de totaal uitgekeerde bonussen van de vorige 6 keer
		SELECT 
			COUNT(Bedrag) 
		FROM Bonus 
		WHERE Bonus_id IN (SELECT TOP 6 Bonus_id 
							FROM Bonus 
							WHERE werknemer_id = @Medewerker_id
							ORDER BY Datum DESC)
		
		--Als het totaal 0 is, dan is de bonus al 6x niet gehaald.
		IF @totaalLaatse6Bonussen = 0
			SELECT @vervolgactie = 'salaris_korten'
		ELSE
			SELECT @vervolgactie = 'geen_bonus'
	END
END

GO

/*Deze SP kan niet worden doorgevoerd omdat de tabellen 
	Factuur, 
	Factuur_bron, 
	Factuur_bron_type,
	Boeking,
	Betaling
niet aan de database zijn toegevoegd, omdat dit niet in de opdracht stond.
De code van deze SP is daarom ook niet getest.
*/
CREATE PROCEDURE controleerTotaalBetalingen (@Factuur_nummer INTEGER)
AS
BEGIN
	DECLARE @totaalTeBetalen FLOAT
	DECLARE @totaalBetaald FLOAT
	DECLARE @orderNumber INT
	
	--Als het om een factuur voor een product-bestelling gaat
	IF (SELECT FBT.Naam FROM Factuur F INNER JOIN Factuur_bron_type FBT ON F.Factuur_bron_type = FBT.id WHERE F.Factuur_id = @Factuur_nummer) = "Order"
	BEGIN --ORDER
		SELECT 
			@totaalTeBetalen = SUM(OD.Unit_sale_price * OD.Quantity) 
		FROM Order_details OD
			INNER JOIN Factuur F 
			ON OD.Order_detail_code = F.Factuur_bron
		WHERE F.id = @Factuur_id
		GROUP BY F.id
	END
	ELSE --Er zijn maar 2 mogelijkheden, dus als het geen product-bestelling is, dan is het een reisboeking
	BEGIN --BOEKING
		SELECT 
			@totaalTeBetalen = B.Boekingbedrag 
		FROM Boeking B 
			INNER JOIN Factuur F 
			ON B.Boeking_id = F.Factuur_bron 
		WHERE F.id = @Factuur_id
	END
	
	SELECT @totaalBetaald = SUM(B.Bedrag)
	FROM Betaling B 
	WHERE B.Factuur_id = @Factuur_nummer
	GROUP BY B.Factuur_id
	
	--Als alles betaald is, dan de bestelling kopieren naar de verwerkt tabel
	IF @totaalTeBetalen >= @totaalBetaald
	BEGIN
		SELECT @orderNumber = F.Factuur_bron FROM Factuur F WHERE F.id = @Factuur_id
		
		--Regels verplaatsen
		INSERT INTO Order_details_Verwerkt
		SELECT * FROM Order_details WHERE Order_number = @orderNumber
		
		--Header verplaatsen
		INSERT INTO Order_header_verwerkt
		SELECT * FROM Order_header WHERE Order_number = @orderNumber
		
		DELETE FROM Order_details_Verwerkt WHERE Order_number = @orderNumber
		DELETE FROM Order_header_verwerkt WHERE Order_number = @orderNumber
	END
END

GO

-------------
-------------
-------------
--OK
CREATE TRIGGER spanOfControl ON werknemer
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @aantalMedewerkers INTEGER
	
	--Tel het aantal werknemers die dezelfde manager hebben.
	SELECT 
		@aantalMedewerkers = COUNT(*) 
	FROM werknemers 
	WHERE manager = (SELECT manager 
					FROM Inserted)	
	
	--Als er 12 of meer medewerkers zijn met deze manager,
	--dan mag de toe te voegen werknemer niet worden toegevoegd.
	IF @aantalMedewerkers >= 12
		ROLLBACK
END

GO

--OK
CREATE TRIGGER controleSalaris ON werknemer
FOR INSERT 
AS
BEGIN
	DECLARE @minSalaris MONEY
	DECLARE @maxSalaris MONEY

	--Haal de max en min salaris op voor de opgegeven functie	
	SELECT 
		@minSalaris = salaris_min, 
		@maxSalaris = salaris_max 
	FROM Functie 
	WHERE Functie_id = (SELECT Functie FROM Inserted)
	
	--Als het opgegeven salaris niet tussen het min en max inzit, dan niet doorvoeren 
	IF NOT ((SELECT Salaris FROM Inserted) BETWEEN @minSalaris AND @maxSalaris)
		ROLLBACK
END

GO

--OK
CREATE TRIGGER checkLocatieWerknemer ON Order_header
FOR INSERT
AS
BEGIN
	/* 
	Sales_brache ophalen van de toegevoegde order;
	Deze moet gelijk zijn aan de sales_branche van de toevoegende medewerker
	*/
	IF (SELECT Sales_branche_code FROM Inserted) <> (SELECT Sales_branche_code FROM Werknemer WHERE werknemer_id = (SELECT werknemer_id FROM Inserted))
	BEGIN
		ROLLBACK
	END
END

GO

--OK
CREATE TRIGGER checkStatusVolgorde ON Order_header
FOR UPDATE
AS
BEGIN
	/*
	Een statusverandering mag alleen naar een status met een id dat 1 hoger ligt
	*/
	IF (SELECT [status] FROM Inserted) <= ((SELECT [status] FROM Order_Header WHERE Order_Number = (SELECT Order_Number FROM Inserted)) + 1)
	BEGIN
		ROLLBACK
	END
END

GO