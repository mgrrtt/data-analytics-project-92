-- запрос, который считает общее количество покупателей из таблицы customers
SELECT COUNT(customer_id) AS customers_count
FROM customers;


-- Топ-10 продавцов с наибольшей выручкой
SELECT
  CONCAT(employees.first_name, ' ', employees.last_name) AS name,
  COUNT(sales.sales_id) AS operations,
  ROUND(SUM(sales.quantity * products.price), 0) AS income
FROM employees
INNER JOIN sales
  ON sales.sales_person_id = employees.employee_id
INNER JOIN products
  ON sales.product_id = products.product_id
GROUP BY employees.employee_id
ORDER BY income DESC
LIMIT 10;


-- Продавцы, чья выручка ниже средней выручки всех продавцов
SELECT
  CONCAT(employees.first_name, ' ', employees.last_name) AS name,
  ROUND(AVG(sales.quantity * products.price), 0) AS average_income
FROM employees
INNER JOIN sales
  ON sales.sales_person_id = employees.employee_id
INNER JOIN products
  ON sales.product_id = products.product_id
GROUP BY employees.employee_id
HAVING ROUND(AVG(sales.quantity * products.price), 0) < (
    SELECT
      ROUND(AVG(sales.quantity * products.price), 0) AS average_all_income
    FROM sales
    INNER JOIN products
      ON sales.product_id = products.product_id
  )
ORDER BY average_income;


-- Выручка всех продавцов по дням недели
SELECT
  CONCAT(employees.first_name, ' ', employees.last_name) AS name,
  TO_CHAR(sales.sale_date, 'day') AS weekday,
  ROUND(SUM(sales.quantity * products.price), 0) AS income
FROM employees
INNER JOIN sales
  ON sales.sales_person_id = employees.employee_id
INNER JOIN products
  ON sales.product_id = products.product_id
GROUP BY TO_CHAR(sales.sale_date, 'ID'), 1, 2
ORDER BY TO_CHAR(sales.sale_date, 'ID'), name;

