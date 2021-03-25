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
WHERE price BETWEEN 10000 AND 20000;
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
SELECT *
FROM phones
order by quantity ASC;
/* */
SELECT *,
  extract(
    'year'
    from age ("birthday")
  ) AS "age"
FROM users
ORDER BY "age" ASC,
  "firstName" DESC;
/* */
SELECT sum(quantity),
  brand
FROM phones
GROUP BY brand
HAVING sum(quantity) > 77000;
/* */
SELECT id,
  char_length(concat("firstName", '', "lastName")) AS "l"
FROM users
ORDER BY l DESC
limit 1;
/* */
SELECT char_length(concat("firstName", '', "lastName")) AS "Name length",
  count(*) AS "Amount"
FROM users
GROUP BY "Name length"
HAVING char_length(concat("firstName", '', "lastName")) < 18;
/* */
SELECT "email",
  char_length("email") AS "l"
FROM users
GROUP BY "email"
HAVING "email" ILIKE 'm%'
  AND char_length("email") >= 25;
/* */
SELECT char_length("email") AS "length",
  count(*)
FROM users --WHERE "email" LIKE 'm%'
GROUP BY "length"
HAVING count(*) >= 10
ORDER BY "length";
/* 1 */
SELECT pto."phoneId",
  o.id,
  p.brand
FROM phones_to_orders AS pto
  JOIN orders AS o ON pto."orderId" = o.id
  JOIN phones AS p ON pto."phoneId" = p.id
WHERE o.id = 3;
/* 2 */
SELECT count(o.id),
  u.id,
  u.email
FROM users AS u
  JOIN orders AS o ON o."userId" = u.id
GROUP BY u.id
ORDER BY u.id;
/* 3 */
SELECT count(p.id),
  pto."orderId"
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
GROUP BY pto."orderId"
ORDER BY pto."orderId";
/* 4 */
SELECT p.id,
  sum(pto.quantity) AS "Самый популярный"
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
GROUP BY p.id
ORDER BY "Самый популярный" DESC
LIMIT 1;
/* 5 */
SELECT "uid_with_pid"."userId",
  count("uid_with_pid"."phoneId")
FROM (
    select u.id as "userId",
      p.id as "phoneId"
    from users AS u
      JOIN orders AS o ON o."userId" = u.id
      JOIN phones_to_orders AS pto ON pto."orderId" = o.id
      JOIN phones AS p ON p.id = pto."phoneId"
    GROUP BY u.id,
      p.id
    ORDER BY u.id
  ) AS "uid_with_pid"
GROUP BY "uid_with_pid"."userId";
/* Извлечь всех пользователей у которых кол-во заказов выше среднего */
WITH users_with_orders AS (
  SELECT u.id,
    count(o.id) AS "sumOrders"
  FROM users AS u
    JOIN orders AS o ON o."userId" = u.id
  GROUP BY u.id
)
SELECT *
FROM users_with_orders AS uwo
WHERE uwo."sumOrders" > (
    SELECT avg(uwo."sumOrders")
    FROM users_with_orders uwo
  );
  /* Создать таблицу tasks  */
  CREATE TABLE "tasks" (
    id serial PRIMARY KEY,
    userId REFERENCES users(id),
    task varchar(250) NOT NULL CHECK (constrains != ''),
    isDone boolean NOT NULL
  );