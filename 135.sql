CREATE TABLE owners(
  ID		SERIAL PRIMARY KEY,
  username	TEXT NOT NULL,
  age		INTEGER NOT NULL,
  state		TEXT NOT NULL
);

CREATE TABLE customers(
  ID		SERIAL PRIMARY KEY,
  username		TEXT NOT NULL,
  age		INTEGER NOT NULL,
  state		TEXT NOT NULL
);

CREATE TABLE categories(
  ID		SERIAL PRIMARY KEY,
  c_name		TEXT NOT NULL,
  description TEXT
);

CREATE TABLE products(
  id            SERIAL PRIMARY KEY,
  p_name    TEXT,
  sku           INTEGER UNIQUE,
  category_id   INTEGER REFERENCES categories (ID) NOT NULL,
  price     REAL
);

CREATE TABLE cart_items(
  id     SERIAL PRIMARY KEY,
  p_name  TEXT,
  price   REAL,
  amount  INTEGER,
  owner   INTEGER REFERENCES customers (ID) NOT NULL,
  product_id  INTEGER REFERENCES products (ID) NOT NULL
);

CREATE TABLE purchased_items(
  id     SERIAL PRIMARY KEY,
  p_name  TEXT,
  price   REAL,
  amount  INTEGER,
  owner   INTEGER REFERENCES customers (ID) NOT NULL
);

 INSERT INTO categories (c_name, description) values ('food', 'eat..');
 INSERT INTO categories (c_name, description) values ('drink', 'drink..');
 INSERT INTO categories (c_name, description) values ('birth control', 'prevent your girlfriend from pregnancy');

 INSERT INTO products (p_name, sku, category_id, price) values ('durex', 2001, 3, 6);
 INSERT INTO products (p_name, sku, category_id, price) values ('durex1', 2002, 3, 7);
 INSERT INTO products (p_name, sku, category_id, price) values ('durex2', 2003, 3, 8);
 INSERT INTO products (p_name, sku, category_id, price) values ('okamato', 2012, 3, 10);
 INSERT INTO products (p_name, sku, category_id, price) values ('jissbon', 2341, 3, 2);
 INSERT INTO products (p_name, sku, category_id, price) values ('trojan', 1203, 1, 3);


 INSERT INTO products (p_name, sku, category_id, price) values ('banana', 0001, 1, 2);
 INSERT INTO products (p_name, sku, category_id, price) values ('banana chips', 0002, 1, 5);
 INSERT INTO products (p_name, sku, category_id, price) values ('banana milk', 0010, 2, 10);
 INSERT INTO products (p_name, sku, category_id, price) values ('apple juice', 1222, 2, 30);

