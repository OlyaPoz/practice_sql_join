/* 
 Типы ассоциации
 
 1 => : <= 1 
 1  : <= m   
 m : <= m_to_n => : n
 
 <= - REFERENCES
 */
CREATE TABLE "phones"(
  id serial PRIMARY KEY,
  brand varchar(64) NOT NULL,
  model varchar(64) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0),
  quantity int NOT NULL CHECK (quantity > 0),
  UNIQUE(brand, model)
);
/*  */
CREATE TABLE "orders"(
  id serial PRIMARY KEY,
  "createdAt" timestamp NOT NULL DEFAULT current_timestamp,
  "userId" REFERENCES "users"(id)
);
/*  */
CREATE TABLE "users_to_orders"(
  "orderId" int REFERENCES "orders"(id),
  "userId" int REFERENCES "users"(id),
  quantity int NOT NULL,
  PRIMARY KEY ("orderId", "userId")
)
/*  Посчитать кол-во телефонов, которые были проданы  */
SELECT sum(quantity)
FROM phones_to_orders;
/* Кол-во тел, которые есть на складе */
SELECT sum(quantity)
FROM phones;
/* Средняя цена всех тел */
SELECT avg(price)
FROM phones;
/* Средняя цена каждого бренда тел */
SELECT avg(price),
brand
FROM phones
GROUP BY brand;
/* Стоимость всех телефонов в диапазоне */
SELECT sum(price * quantity)
FROM phones
WHERE  price BETWEEN 10000 AND 20000;
/* Кол-во моделей каждого бренда */
SELECT count(model),
brand
FROM phones
GROUP BY brand;
/* Узнать каких brand тел осталось меньше всего */
SELECT sum(quantity) AS "res",
brand
FROM phones
GROUP BY brand
ORDER BY "res" ASC;
/* model */
SELECT * FROM phones
order by quantity ASC;
/* */
SELECT *,
 extract('year' from age ("birthday")) AS "age"
 FROM users
ORDER BY "age" ASC, "firstName" DESC;
/* */
SELECT sum(quantity), 
brand 
FROM phones
GROUP BY brand
HAVING sum(quantity)>77000;
/* */
SELECT id,
char_length(concat("firstName", '', "lastName")) AS "l"
FROM users
ORDER BY l DESC
limit 1;
/* */
SELECT
char_length(concat("firstName", '', "lastName")) AS "Name length",
count(*) AS "Amount"
FROM users
GROUP BY "Name length"
HAVING char_length(concat("firstName", '', "lastName")) < 18;
/* */
SELECT "email", 
char_length("email") AS "l"
FROM users
GROUP BY "email"
HAVING "email" ILIKE 'm%' AND char_length("email") >= 25;
/* */
SELECT char_length("email") AS "length",
count(*) 
FROM users
--WHERE "email" LIKE 'm%'
GROUP BY "length"
HAVING count(*) >= 10
ORDER BY "length";
/* */
SELECT pto."phoneId", o.id, p.brand
FROM phones_to_orders AS pto
 JOIN orders AS o ON pto."orderId" = o.id
 JOIN phones AS p ON pto."phoneId" = p.id
WHERE o.id = 3;
/* */
SELECT count(pto.quantity),u.*, u.email  
FROM phones_to_orders AS pto
 JOIN users AS u ON pto."orderID" = u.id
 GROUP BY pto.quantity;
