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
CHECK(date_hired >= Geboortedatum),
CHECK(), --MAG ALLEEN GEVULD ZIJN INDIEN FUNCTIE IS "VERKOOPMEDEWERKER"
CHECK(Salaris >= 50 AND Salaris <= 100000)
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
	ON UPDATE RESTRICT
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

