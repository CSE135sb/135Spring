CREATE TABLE product (
    id          SERIAL PRIMARY KEY,
    p_name 		TEXT,
    sku         INTEGER, 
    price 		INTEGER
);

INSERT INTO product (p_name, sku, price) values ('derux', 2001, 6);
INSERT INTO product (p_name, sku, price) values ('trojan', 1203, 3);

