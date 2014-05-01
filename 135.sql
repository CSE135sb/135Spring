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

-- INSERT INTO categories (c_name, description) values ('birth control', 'prevent your girlfriend from pregnancy');
-- INSERT INTO products (p_name, sku, category_id, price) values ('derux', 2001, 1, 6);
-- INSERT INTO products (p_name, sku, category_id, price) values ('trojan', 1203, 1, 3);

