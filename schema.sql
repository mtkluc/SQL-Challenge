-- Set datestyle for consistent date formats
SET datestyle = 'MDY';

-- Table: salaries
CREATE TABLE salaries (
    emp_no INT PRIMARY KEY,
    salary INT 
);

-- Table: departments
CREATE TABLE departments (
    dept_no VARCHAR(50) PRIMARY KEY,
    dept_name VARCHAR(50) 
);

-- Table: titles
CREATE TABLE titles (
    title_id VARCHAR(50) PRIMARY KEY, 
    title VARCHAR(50)  
);

-- Staging table: due to Date issues
CREATE TABLE staging_employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR(50) NOT NULL,
    birth_date TEXT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(50),
    hire_date TEXT
);

-- Table: employees
CREATE TABLE employees (
    emp_no INT PRIMARY KEY, 
    emp_title_id VARCHAR(50) NOT NULL,
    birth_date DATE, 
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(50),
    hire_date DATE,  
    FOREIGN KEY (emp_no) REFERENCES salaries(emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- Table: dept_emp
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(50) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Table: dept_manager
CREATE TABLE dept_manager (
    dept_no VARCHAR(50) NOT NULL,
    emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- to bring employee table info across correctly. ONLY RUN POST importing to staging csv and prior to other tables
INSERT INTO employees (emp_no, emp_title_id, birth_date, first_name, last_name, gender, hire_date)
SELECT 
    emp_no, 
    emp_title_id, 
    TO_DATE(birth_date, 'MM/DD/YYYY'), 
    first_name, 
    last_name, 
    gender, 
    TO_DATE(hire_date, 'MM/DD/YYYY')
FROM staging_employees;

-- drop the staging table
DROP TABLE staging_employees;

-- Check all tables
SELECT * FROM departments
SELECT * FROM dept_emp
SELECT * FROM dept_manager
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM titles