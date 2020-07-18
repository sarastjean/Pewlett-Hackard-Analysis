-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no, title, from_date)
);

DROP TABLE dept_manager CASCADE;

SELECT * FROM titles;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
SELECT * FROM employee_count;

SELECT * FROM salaries
ORDER BY to_date DESC;

DROP TABLE emp_info

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
	INNER JOIN salaries as s
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	 AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

SELECT COUNT (emp_no)
FROM emp_info

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT * FROM manager_info

SELECT ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info

SELECT * FROM skill_drill

SELECT * FROM retirement_info
SELECT * FROM dept_emp

SELECT ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.dept_no
INTO testtwo
FROM retirement_info as ri
	LEFT JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
WHERE dept_no IN ('d005', 'd007');

SELECT * FROM testtwo
		
-- Create new table for retiring employees for Challenge
SELECT 
	e.emp_no, 
	e.first_name,
	e.last_name,
	de.to_date
INTO retirement_challenge
FROM employees as e
	LEFT JOIN dept_emp as de
		ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
		AND(de.to_date = '9999-01-01');
-- Check the table
SELECT * FROM retirement_challenge;	

SELECT COUNT (DISTINCT emp_no)
FROM retirement_challenge

SELECT rc.emp_no, 
		rc.first_name, 
		rc.last_name,
		ti.title,
		ti.from_date,
		sal.salary
INTO retirement_emp
FROM retirement_challenge as rc
	INNER JOIN titles as ti
		ON(rc.emp_no = ti.emp_no)
	INNER JOIN salaries as sal
		ON (ti.emp_no = sal.emp_no);

Select Count (emp_no)
FROM retirement_emp

SELECT * FROM retirement_emp;

--Partition the data to show only the most recent title per employee
SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		salary
INTO retirement_partition
FROM
	(SELECT emp_no,
			first_name,
			last_name,
			title,
			from_date,
			salary, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	 ORDER BY from_date DESC) rn
	 FROM retirement_emp
	 ) tmp WHERE rn = 1
	 ORDER BY emp_no;

SELECT * FROM retirement_partition;

SELECT COUNT(emp_no)
FROM retirement_partition

--Number of Titles Retiring
SELECT COUNT (DISTINCT rp.title) as "Number of Titles Retiring"
FROM retirement_partition as rp;

--Employee Count by Title
SELECT COUNT (rp.emp_no), rp.title
FROM retirement_partition as rp
GROUP BY rp.title
ORDER BY rp.title


-- Create new table for Mentorship Eligibility for Challenge
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO employee_mentors
FROM employees as e
	INNER JOIN titles as ti
		ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1965-1-1' AND '1965-12-31')
	AND (ti.to_date = '9999-01-01');
--Check the table
SELECT * FROM employee_mentors

--Checking for duplicates
SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date
INTO mentorship_program
FROM
	(SELECT emp_no,
			first_name,
			last_name,
			title,
			from_date,
			to_date, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	 ORDER BY from_date DESC) rn
	 FROM employee_mentors
	 ) tmp WHERE rn = 1
	 ORDER BY emp_no;

SELECT * FROM mentorship_program;

SELECT COUNT(mp.emp_no) AS "Number of Available Mentors"
FROM mentorship_program as mp;
		

