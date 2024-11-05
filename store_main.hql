CREATE DATABASE IF NOT EXISTS store;
USE store;

-- Create an external table for customers
CREATE EXTERNAL TABLE customer (
  CustomerID int,
  AccountNumber string,
  CustomerType varchar(1),
  NameStyle boolean,
  Title string,
  FirstName string,
  MiddleName string,
  LastName string,
  Suffix string,
  EmailAddress string,
  EmailPromotion int,
  Phone string,
  AdditionalContactInfo string,
  TerritoryID int,
  territoryName string,
  countryregioncode string,
  `group` string,
  ModifiedDate timestamp,
  change_date timestamp,
  active boolean
)
STORED AS PARQUET
LOCATION '/user/hadoop/output/stores/target/customers';

-- Create an external table for customer demographics
CREATE EXTERNAL TABLE customer_demo (
  customerid int,
  totalpurchaseytd decimal(15,2),
  datefirstpurchase date,
  birthdate date,
  maritalstatus string,
  yearlyincome string,
  gender string,
  totalchildren tinyint,
  numberchildrenathome tinyint,
  education string,
  occupation string,
  homeownerflag string,
  numbercarsowned tinyint,
  commutedistance string,
  create_date date
)
STORED AS ORC
LOCATION '/user/hadoop/output/stores/target/customer_demo';

-- Create an external table for customer demographics history
CREATE EXTERNAL TABLE customer_demo_history (
  customerid int,
  totalpurchaseytd decimal(15,2),
  datefirstpurchase date,
  birthdate date,
  maritalstatus string,
  yearlyincome string,
  gender string,
  totalchildren tinyint,
  numberchildrenathome tinyint,
  education string,
  occupation string,
  homeownerflag string,
  numbercarsowned tinyint,
  commutedistance string,
  create_date date,
  end_date date
)
STORED AS ORC
LOCATION '/user/hadoop/output/stores/target/customer_demo_history';

-- Create an external table for credit card information
CREATE EXTERNAL TABLE creditcard (
  creditcardid int,
  cardtype string,
  cardnumber string,
  expmonth int,
  expyear int,
  modifieddate date,
  create_date date
)
STORED AS ORC
LOCATION '/user/hadoop/output/stores/target/creditcard';

-- Create an external table for products
CREATE EXTERNAL TABLE product (
  productId int,
  name string,
  productnumber string,
  makeflag boolean,
  finishedgoodsflag boolean,
  color string,
  safetystocklevel int,
  reorderpoint int,
  standardcost double,
  listprice double,
  size string,
  sizeunitmeasurecode string,
  weightunitmeasurecode string,
  weight string,
  daystomanufacture int,
  productline string,
  class string,
  style string,
  sellstartdate date,
  sellenddate date,
  discontinueddate date,
  productsubcategory string,
  productcategory string,
  producemodel string,
  catalogdescription string,
  instructions string,
  modifieddate date
)
STORED AS ORC
LOCATION '/user/hadoop/output/stores/target/products';
