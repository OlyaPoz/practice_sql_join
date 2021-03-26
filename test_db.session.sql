CREATE TABLE "customers"(
  id serial PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL,
  "address" jsonb,
  "phone" CHAR(11)
);
/* */
CREATE TABLE "orders"(
  id serial PRIMARY KEY,
  customers_id REFERENCES customers(id) 
  contracts_id REFERENCES contracts(id)
  quantity int NOT NULL,
);
/* */
CREATE TABLE "contracts"(
  id serial PRIMARY KEY,
  custumer_id,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  orders_id int REFERENCES "orders"(id),
);
/* */
CREATE TABLE "products_to_orders"(
  order_id int REFERENCES "orders"(id),
  product_id int REFERENCES "users"(id),
  PRIMARY KEY (order_id, product_id)
);
/* */
CREATE TABLE "shipment"(
  id serial PRIMARY KEY,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
);
/* */
CREATE TABLE "products"(
  id serial PRIMARY KEY,
  name_product VARCHAR(64) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0)
);
/* */
CREATE TABLE "shipment_to_orders_products"(
  shipment_id, 
  product_id,
  order_id,
  quantity CHECK,
  fk() ref pto() primery key(shipment_id, product_id, order_id)
)