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


-- Количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+
SELECT
  CASE
    WHEN age BETWEEN 16 AND 25 THEN '16-25'
    WHEN age BETWEEN 26 AND 40 THEN '26-40'
  ELSE '40+'
  END AS age_category,
  COUNT(customer_id) AS count
FROM customers
GROUP BY 1
ORDER BY 1;


-- Количество уникальных покупателей и выручка, которую они принесли, по месяцам
SELECT
  TO_CHAR(sales.sale_date, 'YYYY-MM') AS date,
  COUNT(DISTINCT customers.customer_id) AS total_customers,
  ROUND(SUM(products.price * sales.quantity), 0) AS income
FROM sales
INNER JOIN customers
  ON sales.customer_id = customers.customer_id
INNER JOIN products
  ON sales.product_id = products.product_id
GROUP BY 1
ORDER BY 1;


-- Покупатели, первая покупка которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0)
SELECT DISTINCT ON (CONCAT(customers.first_name, ' ', customers.last_name))
  CONCAT(customers.first_name, ' ', customers.last_name) AS customer,
  sales.sale_date,
  CONCAT(employees.first_name, ' ', employees.last_name) AS seller
FROM sales
INNER JOIN customers
  ON sales.customer_id = customers.customer_id
INNER JOIN employees
  ON employees.employee_id = sales.sales_person_id
INNER JOIN products
  ON sales.product_id = products.product_id
WHERE products.price = 0
ORDER BY
  CONCAT(customers.first_name, ' ', customers.last_name),
  customers.customer_id,
  sales.sale_date;

