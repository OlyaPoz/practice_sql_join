SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'iphone' THEN 'Apple'
      ELSE 'other'
    END
  ) AS "manufacturer"
FROM phones;
/* */
SELECT *,
  (
    CASE
      WHEN "price" < 10000 THEN 'cheap'
      WHEN "price" BETWEEN 10000 AND 20000 THEN 'mid'
      ELSE 'flagman'
    END
  ) AS "price filter"
FROM phones;
/* */
SELECT u.id,
  u.email,
  count(o.id),
  (
    CASE
      WHEN count(o.id) >= 5 THEN 'Пост пок'
      WHEN count(o.id) > 2 THEN 'Активн пок'
      ELSE 'Покуп'
    END
  ) AS "orders status"
FROM users AS u
  JOIN orders AS o ON u.id = o."userId"
GROUP BY u.id;
/* VIEW */
CREATE OR REPLACE VIEW "full_info_users" as (
    SELECT id,
      concat("firstName", ' ', "lastName") AS "fullName",
      extract(
        year
        from age("birthday")
      ) AS "age",
      (
        CASE
          WHEN "isMale" THEN 'male'
          ELSE 'female'
        END
      ) AS "gender"
    FROM users
  );

  CREATE DATABASE my_db;