DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS manufactures;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS price_change;
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS purchases_items;

CREATE TABLE manufactures(
   manufacturer_id SERIAL PRIMARY KEY,
   manufacturer_name VARCHAR(100) NOT NULL
   manufacturer_legal_entity VARCHAR(100) NOT NULL

);


CREATE TABLE categories(
   category_id SERIAL PRIMARY KEY,             
   category_name VARCHAR(100) NOT NULL
                                   
); 


CREATE TABLE stores(
   store_id SERIAL PRIMARY KEY,             
   store_name VARCHAR(255) NOT NULL
                                   
);  


CREATE TABLE customers(
   customer_id SERIAL PRIMARY KEY,             
   customer_fname VARCHAR(100) NOT NULL,
   customer_lname VARCHAR(100) NOT NULL
   customer_gender VARCHAR(100) NOT NULL,
   customer_phone VARCHAR(100) NOT NULL
                                   
);  


CREATE TABLE price_change(
   product_id NUMERIC(20) PRIMARY KEY,             
   price_change_ts TIMESTAMP NOT NULL,
   new_price NUMERIC(9,2) NOT NULL
                                   
);  


CREATE TABLE products(
   product_id SERIAL PRIMARY KEY,
   product_name VARCHAR(255) NOT NULL,
   product_picture_url VARCHAR(255) NOT NULL,
   product_description VARCHAR(255) NOT NULL,
   product_age_restriction INTEGER NOT NULL,
   category_id INT 
         REFERENCES categories(category_id),
   manufacturer_id INT
         REFERENCES manufactures(manufacturer_id)
);



CREATE TABLE purchases(
   purchase_id SERIAL PRIMARY KEY,             
   purchase_date TIMESTAMP NOT NULL,
   purchase_payment_type VARCHAR(100) NOT NULL,
   store_id INT NOT NULL
         REFERENCES stores(store_id),
   customer_id INT NOT NULL
         REFERENCES customers(customer_id)
);



CREATE TABLE deliveries(
   delivery_id BIGINT PRIMARY KEY,
   delivery_date TIMESTAMP NOT NULL,
   product_count INTEGER NOT NULL,
   store_id INT
         REFERENCES stores(store_id),
   product_id INT NOT NULL
         REFERENCES price_change(product_id)
);



CREATE TABLE purchase_items(
   product_count NUMERIC(20) NOT NULL,
   product_price NUMERIC(9,3) NOT NULL,
   product_id INT NOT NULL         
         REFERENCES products(product_id),
   purchase_id INT NOT NULL
         REFERENCES purchases(purchase_id)
);


