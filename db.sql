-- vim: set syn=pgsql: --

CREATE TABLE casurl_lookup (
    url_id   varchar(2) PRIMARY KEY,
    url_mask varchar
);

INSERT INTO casurl_lookup VALUES
    ('cc', 'http://www.commonchemistry.org/ChemicalDetail.aspx?ref=%s'),
    ('sa', 'http://www.sigmaaldrich.com/catalog/search?term=%s&interface=CAS%%20No.&focus=product'),
    ('no', NULL);

CREATE TABLE casnumber_lookup (
    cas_nbr  varchar(12)  UNIQUE,
    url_id   varchar(2)   REFERENCES casurl_lookup(url_id)
);

CREATE TABLE product (
    name     varchar      UNIQUE,
    formula  varchar(80),
    cas_nbr  varchar(12)  REFERENCES casnumber_lookup(cas_nbr)
);

CREATE VIEW pool AS
    SELECT product.name,
           product.formula,
           product.cas_nbr,
           replace(casurl_lookup.url_mask,
                   '%s',
                   product.cas_nbr) AS cas_url
    FROM product
        NATURAL JOIN casnumber_lookup
        NATURAL JOIN casurl_lookup
    ORDER BY product.name;

/*  2014-10-23
 *
 *  Add product quantity to product table.
 *
 */

CREATE TABLE unit_lookup (
    unit     varchar(2) PRIMARY KEY
);

INSERT INTO unit_lookup VALUES
    ('mg'),
    ('mL');

ALTER TABLE product ADD COLUMN quantity int;
ALTER TABLE product ADD COLUMN unit varchar(2) REFERENCES unit_lookup(unit);

/*  2015-02-09
 *
 *  Refactor product quantity to its own table.
 *
 */

ALTER TABLE unit_lookup
    ADD COLUMN state text UNIQUE;

UPDATE unit_lookup
SET state = 'solid' WHERE unit = 'mg';

UPDATE unit_lookup
SET state = 'liquid' WHERE unit = 'mL';

-- save state in product

ALTER TABLE product
    ADD COLUMN state text REFERENCES unit_lookup(state);

UPDATE product
    SET state = unit_lookup.state
    FROM unit_lookup
    WHERE product.unit = unit_lookup.unit;

-- move quantity out of product

CREATE TABLE product_quantity (
    name      varchar   REFERENCES product(name) ON UPDATE CASCADE,
    quantity  int       DEFAULT 0
);

INSERT INTO product_quantity
    SELECT name, quantity
    FROM product;

ALTER TABLE product
    DROP COLUMN quantity,
    DROP COLUMN unit;

-- summarize stock in a view

CREATE VIEW stock AS
    SELECT product.name,
        sum(product_quantity.quantity) AS qty,
        unit_lookup.unit
        FROM product_quantity
        JOIN product ON product_quantity.name = product.name
        NATURAL JOIN unit_lookup
        GROUP BY product.name, unit_lookup.unit
        HAVING sum(product_quantity.quantity) != 0;

/*
# SQLITE

PRAGMA foreign_keys = 1;
.mode line
.separator ";"
.import './db/cas_number.txt' casnumber_lookup
.import './db/product.txt' product

*/

