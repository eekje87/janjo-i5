/*	
	Fysiek ontwerp v0.2
	Secundaire indexen referentie Implementatiemodel v0.3
*/


-- PRODUCT

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Product_type_code en/ of Product_name. */
CREATE INDEX idx_Product_type_code
	ON product (Product_type_code ASC);	
CREATE INDEX idx_Product_name
	ON product (Product_name ASC);

-- MEDEWERKERS

/*	Afgezien van de PK is de verwachting dat er veel gezochat zal gaan worden
		op Country_code en/ of Address1. */
CREATE INDEX idx_Country_code
	ON Sales_Branche (Country_code ASC);
CREATE INDEX idx_Address1
	ON Sales_Branche (Address1 ASC);

/*	Om de SP controleerBonusGehaald vlot te kunnen laten verlopen wordt
		er een index gemaakt op Werknemer_id. */
CREATE INDEX idx_Werknemer_id
	ON Bonus (Werknemer_id ASC);

/*	Afgezien van de PK en ook om de SP controleerBonusGehaald vlot te
		kunnen laten verlopen is er een index gemaakt op Sales_target. */
CREATE INDEX idx_Sales_target
	ON Sales_target (Sales_target ASC);

/*	Afgezien van de PK en ook om de SP controleerSalarisMetManager vlot te
		kunnen laten verlopen is er een index gemaakt op Salaris en op Manager. */
CREATE INDEX idx_Salaris
	ON werknemer (Salaris ASC);
CREATE INDEX idx_Manager
	ON werknemer (Manager ASC);

-- HRM
/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Werkervaring. */
CREATE INDEX idx_Werkervaring
	ON Werknemer_CV (Werkervaring ASC);

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Naam. */
CREATE INDEX idx_Naam
	ON Cursus (Naam ASC);

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Werknemer_id. */
CREATE INDEX idx_Werknemer_id
	ON	Training (Werknemer_id ASC);

-- ORDERS

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Werknemer_id. */
CREATE INDEX idx_Werknemer_id
	ON Order_header (Werknemer_id ASC);

/*	Afgezien van de PK en ook om de SP controleerBonusGehaald vlot te
		kunnen laten verlopen hoort er een index gemaakt te worden op
		Order_number en op Product_number. */
CREATE INDEX idx_Order_number
	ON Order_details (Order_number ASC);

CREATE INDEX idx_Product_number
	ON Order_details (Product_number ASC);

-- CUSTOMER

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Klant_naam. */
CREATE INDEX idx_Klant_naam
	ON Klant (Klant_naam ASC);

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Retailer_type_code. */
CREATE INDEX idx_Retailer_type_code
	ON Retailer (Retailer_type_code ASC);

-- VOORRAAD EN LOGISTIEK

/*	Afgezien van de PK is de verwachting dat er veel gezocht zal gaan worden
		op Product_number en op Inventory_levels. */
CREATE INDEX idx_Product_number
	ON Inventory_levels (Product_number ASC);

CREATE INDEX idx_Inventory_count
	ON Inventory_levels (Inventory_count ASC);

