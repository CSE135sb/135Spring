CREATE TABLE products (
    id          	SERIAL PRIMARY KEY,
    p_name 		TEXT,
    sku         	INTEGER, 
    category_id		INTEGER REFERENCES categories (ID) NOT NULL,
    price 		INTEGER
);

INSERT INTO products (p_name, sku, category_id, price) values ('derux', 2001, 1, 6);
INSERT INTO products (p_name, sku, category_id, price) values ('trojan', 1203, 1, 3);

