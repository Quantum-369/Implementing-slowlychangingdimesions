use store_stage;

-- create a temporary table
create temporary table customer_temp (
	customerid int,
	accountnumber  string,
	customertype varchar(1),
	namestyle boolean,
	title string,
	firstname string ,
	middlename  string,
	lastname string ,
	suffix string ,
	emailaddress  string,
	emailpromotion int,
	phone  string,
	additionalcontactinfo  string,
	territoryid int,
	territoryname  string,
	countryregioncode  string,
	`group`  string,
	modifieddate bigint,
	change_date timestamp,
	active boolean
)
stored as parquet;


INSERT INTO customer_temp 
SELECT 
    customerid,
    accountnumber,
    customertype,
    namestyle,
    title,
    firstname,
    middlename,
    lastname,
    suffix,
    emailaddress,
    emailpromotion,
    phone,
    additionalcontactinfo,
    territoryid,
    territoryname,
    countryregioncode,
    `group`,
    modifieddate,
    current_timestamp() AS change_date,  
    true AS active                      
FROM customer
WHERE customerid NOT IN (SELECT customerid FROM customer_temp);


-- Example to handle changes (theoretical example, adjust fields and logic as needed)
INSERT INTO customer_temp
SELECT 
    a.customerid,
    a.accountnumber,
    a.customertype,
    a.namestyle,
    a.title,
    a.firstname,
    a.middlename,
    a.lastname,
    a.suffix,
    a.emailaddress,
    a.emailpromotion,
    a.phone,
    a.additionalcontactinfo,
    a.territoryid,
    a.territoryname,
    a.countryregioncode,
    a.`group`,
    a.modifieddate,
    current_timestamp() as change_date,
    false as active  
FROM customer_temp a
JOIN customer b ON a.customerid = b.customerid
WHERE NOT (a.`group` = b.`group` and
           a.accountnumber = b.accountnumber and
           a.customertype = b.customertype and
           a.firstname = b.firstname and
           a.middlename = b.middlename and
           a.emailaddress = b.emailaddress and
           a.phone = b.phone and
           a.territoryid = b.territoryid and
           a.countryregioncode = b.countryregioncode);

INSERT INTO customer_temp
SELECT 
    b.customerid,
    b.accountnumber,
    b.customertype,
    b.namestyle,
    b.title,
    b.firstname,
    b.middlename,
    b.lastname,
    b.suffix,
    b.emailaddress,
    b.emailpromotion,
    b.phone,
    b.additionalcontactinfo,
    b.territoryid,
    b.territoryname,
    b.countryregioncode,
    b.`group`,
    b.modifieddate,
    current_timestamp() AS change_date,
    true AS active
FROM customer b
LEFT JOIN customer_temp a ON b.customerid = a.customerid
WHERE a.active IS NULL OR a.active = false;  


ALTER TABLE customer ADD COLUMNS (
    change_date timestamp,
    active boolean
);

ALTER TABLE customer_temp ADD COLUMNS (demographics string);


-- Overwrite production table with all temporary data
INSERT OVERWRITE TABLE customer
SELECT
  customerid,
  accountnumber,
  customertype,
  namestyle,
  title,
  firstname,
  middlename,
  lastname,
  suffix,
  emailaddress,
  emailpromotion,
  phone,
  additionalcontactinfo,
  territoryid,
  territoryname,
  countryregioncode,
  `group`,
  modifieddate,
  demographics,   
  change_date,
  active
FROM customer_temp;


DROP TABLE customer_temp;