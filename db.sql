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

/*
# SQLITE

PRAGMA foreign_keys = 1;
.mode line
.separator ";"
.import './db/cas_number.txt' casnumber_lookup
.import './db/product.txt' product

*/

