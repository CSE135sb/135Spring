CREATE TABLE p_c (
    id          SERIAL,
    product     INTEGER REFERENCES product (ID) NOT NULL,
    category   	INTEGER REFERENCES category (ID) NOT NULL
);

INSERT INTO students (product, category) values (1, 1);


