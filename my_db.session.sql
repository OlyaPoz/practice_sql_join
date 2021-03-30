CREATE TABLE "users" (
  "id" serial PRIMARY KEY,
  "login" varchar(64) NOT NULL CHECK ("login" != ''),
  "email" varchar(256) NOT NULL UNIQUE CHECK ("email" != ''),
  "password" varchar(32) NOT NULL CHECK ("password" != '')
);
/* */
CREATE TABLE "employees" (
  "id" serial PRIMARY KEY,
  "salary" numeric(10, 2) NOT NULL CHECK ("salary" >= 0),
  "department" varchar(64) NOT NULL,
  "position" varchar(64) NOT NULL,
  "hire_date" timestamp NOT NULL DEFAULT current_timestamp
);
/* */
ALTER TABLE "users" DROP COLUMN "password";
/* */
ALTER TABLE "users"
ADD COLUMN "password_hash" text NOT NULL;
/* */
ALTER TABLE "users"
ADD COLUMN "is_employees" boolean NOT NULL;
ALTER TABLE "users" DROP COLUMN "is_employees";
/* */
ALTER TABLE "employees"
ADD COLUMN "user_id" int REFERENCES "users"("id");
/* */
INSERT INTO "users" (
    "login",
    "email",
    "password_hash",
    "is_employees"
  )
VALUES (
    'test1',
    'test@gmail.com',
    'bfghwegbhcfbh1'
  ),
  (
    'test2',
    'test1@gmail.com',
    'bfghwegbhcfbh2'
  ),
  (
    'test3',
    'test2@gmail.com',
    'bfghwegbhcfbh3'
  ),
  (
    'test4',
    'test3@gmail.com',
    'bfghwegbhcfbh4'
  ),
  (
    'test5',
    'test4@gmail.com',
    'bfghwegbhcfbh5'
  ),
  (
    'test6',
    'test5@gmail.com',
    'bfghwegbhcfbh6'
  );
/* */
INSERT INTO "employees" ("salary", "department", "position", "hire_date", "user_id")
VALUES ('1000', 'HR', 'fnjwe', '1999-01-01', 2),
  ('500', 'Finanse', 'fnjwefr', '2009-01-01', 3),
  ('1200', 'HR', 'fnjwetye', '1995-01-01', 4),
  ('300', 'HR', 'fnjwrtge', '2013-01-01', 5);
/* */
SELECT u.*,
  COALESCE(e."salary", 0)
FROM "users" u
  LEFT JOIN "employees" e ON u."id" = e."user_id";
  /* */
  SELECT *
FROM "users" u
WHERE u."id" NOT IN (SELECT e."user_id" FROM "employees" e);

/* */
/* 
 WINDOW FUNCTIONS 
 */
CREATE SCHEMA wf;
/*  */
CREATE TABLE wf.employees(
  id serial PRIMARY KEY,
  "name" varchar(256) NOT NULL CHECK("name" != ''),
  salary numeric(10, 2) NOT NULL CHECK (salary >= 0),
  hire_date timestamp NOT NULL DEFAULT current_timestamp
);
/*  */
CREATE TABLE wf.departments(
  id serial PRIMARY KEY,
  "name" varchar(64) NOT NULL
);
/*  */
ALTER TABLE wf.employees
ADD COLUMN department_id int REFERENCES wf.departments;
/*  */
INSERT INTO wf.departments("name")
VALUES ('SALES'),
  ('HR'),
  ('DEVELOPMENT'),
  ('QA'),
  ('TOP MANAGEMENT');
INSERT INTO wf.employees ("name", salary, hire_date, department_id)
VALUES ('TEST TESTov', 10000, '1990-1-1', 1),
  ('John Doe', 6000, '2010-1-1', 2),
  ('Matew Doe', 3456, '2020-1-1', 2),
  ('Matew Doe1', 53462, '2020-1-1', 3),
  ('Matew Doe2', 124543, '2012-1-1', 4),
  ('Matew Doe3', 12365, '2004-1-1', 5),
  ('Matew Doe4', 1200, '2000-8-1', 5),
  ('Matew Doe5', 2535, '2010-1-1', 2),
  ('Matew Doe6', 1000, '2014-1-1', 3),
  ('Matew Doe6', 63456, '2017-6-1', 1),
  ('Matew Doe7', 1000, '2020-1-1', 3),
  ('Matew Doe8', 346434, '2015-4-1', 2),
  ('Matew Doe9', 3421, '2018-1-1', 3),
  ('Matew Doe0', 34563, '2013-2-1', 5),
  ('Matew Doe10', 2466, '2011-1-1', 1),
  ('Matew Doe11', 9999, '1999-1-1', 5),
  ('TESTing 1', 1000, '2019-1-1', 2);
/*  */
SELECT d.name,
  count(e.id)
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/*  */
SELECT e.*,
  d.name
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  /*  */
SELECT avg(e.salary),
  d.id
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
GROUP BY d.id;
/* JOIN
 user|dep|avg dep salary
 
 */
SELECT e.*,
  d.name,
  "d_a_s"."avg_salary"
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id
  JOIN (
    SELECT avg(e.salary) AS "avg_salary",
      d.id
    FROM wf.departments d
      JOIN wf.employees e ON e.department_id = d.id
    GROUP BY d.id
  ) AS "d_a_s" ON d.id = d_a_s.id;
  /* WINDOW FUNC 
   user|dep|avg dep salary
   */
SELECT e.*,
  d.name,
  round(avg(e.salary) OVER (PARTITION BY d.id)) as "avg_dep_salary",
  avg(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;
  /* */
  SELECT e.*,
  d.name,
  round(sum(e.salary) OVER (PARTITION BY d.id)) as "sum_dep_salary",
  sum(e.salary) OVER ()
FROM wf.departments d
  JOIN wf.employees e ON e.department_id = d.id;