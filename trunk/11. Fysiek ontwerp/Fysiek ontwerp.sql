-- Secundaire indexen

-- PRODUCT
CREATE INDEX idx_Product_type_code
	ON product (Product_type_code ASC);
	
CREATE INDEX idx_Product_name
	ON product (Product_name ASC);

-- MEDEWERKERS
CREATE INDEX idx_Country_code
	ON Sales_Branche (Country_code ASC);

CREATE INDEX idx_Address1
	ON Sales_Branche (Address1 ASC);

CREATE INDEX idx_Werknemer_id
	ON Bonus (Werknemer_id ASC);

CREATE INDEX idx_Sales_target
	ON Sales_target (Sales_target ASC);

CREATE INDEX idx_Sales_branche_code
	ON werknemer (Sales_branche_code ASC);

-- HRM
CREATE INDEX idx_Naam
	ON Cursus (Naam ASC);

CREATE INDEX idx_Werknemer_id
	ON	Training (Werknemer_id ASC);

-- ORDERS
CREATE INDEX idx_Retailer_site_code
	ON Order_header (Retailer_site_code ASC);

CREATE INDEX idx_Werknemer_id
	ON Order_header (Werknemer_id ASC);

CREATE INDEX idx_Order_number
	ON Order_details (Order_number ASC);

CREATE INDEX idx_Product_number
	ON Order_details (Product_number ASC);

-- CUSTOMER
CREATE INDEX idx_Klant_naam
	ON Klant (Klant_naam ASC);

CREATE INDEX idx_Retailer_type_code
	ON Retailer (Retailer_type_code ASC);

-- VOORRAAD EN LOGISTIEK
CREATE INDEX idx_Product_number
	ON Inventory_levels (Product_number ASC);

CREATE INDEX idx_Inventory_count
	ON Inventory_levels (Inventory_count ASC);

