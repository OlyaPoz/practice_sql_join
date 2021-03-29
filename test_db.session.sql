CREATE TABLE "customers"(
  id serial PRIMARY KEY,
  "name" VARCHAR(64) NOT NULL,
  "address" jsonb,
  "phone" CHAR(11)
);
/* */
CREATE TABLE "orders"(
  id serial PRIMARY KEY,
  customers_id int REFERENCES customers(id), 
  contracts_id int REFERENCES contracts(id),
  PRIMARY KEY (order_id, product_id)
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
  quantity int NOT NULL,
  PRIMARY KEY (order_id, product_id)
);
/* */
CREATE TABLE "shipment"(
  id serial PRIMARY KEY,
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  product_id int NOT NULL,
  PRIMARY KEY (product_id)
);
/* */
CREATE TABLE "products"(
  id serial PRIMARY KEY,
  name_product VARCHAR(64) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0)
);

