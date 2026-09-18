create database project;
use  project;


-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: Payroll
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 1. EMPLOYEE INSIGHTS

-- 	How many unique employees are currently in the system?
select count(distinct firstname,lastname) from employee;

-- 	Which departments have the highest number of employees?
select jobdept,count(job_id) as high_employees from jobdepartment
group by jobdept
order by high_employees desc;

-- 	What is the average salary per department?
select j.jobdept,avg(s.annual) as avg_salary from salarybonus s
join jobdepartment j
on s.job_id = j.job_id
group by j.jobdept;

-- Who are the top 5 highest-paid employees?
select e.firstname ,e.lastname, s.annual from salarybonus s
join jobdepartment j
on s.job_id = j.job_id
join employee e
on e.job_id=j.job_id
order by s.amount desc 
limit 5;

-- What is the total salary expenditure across the company?
select sum(annual) from salarybonus;


-- 2. JOB ROLE AND DEPARTMENT ANALYSIS

-- How many different job roles exist in each department?
select jobdept,count(name) no_of_job_roles from jobdepartment
group by jobdept;

-- What is the average salary range per department?
select j.jobdept, avg(s.amount) avg_salary from salarybonus s
join jobdepartment j
on s.job_id = j.job_id
group by j.jobdept;

-- Which job roles offer the highest salary?
select j.name,s.amount from jobdepartment j
join salarybonus s 
on j.job_id = s.job_id
order by s.amount desc ;

-- Which departments have the highest total salary allocation?
select sum(s.amount) total_salary,j.jobdept from salarybonus s
join jobdepartment j
on j.job_id = s.job_id
group by j.jobdept 
order by sum(s.amount) desc;

-- 4. LEAVE AND ABSENCE PATTERNS

-- Which year had the most employees taking leaves?
SELECT YEAR(date) AS Leave_Year,COUNT(DISTINCT emp_ID) AS Employees_On_Leave
FROM Leaves
GROUP BY YEAR(date)
ORDER BY Employees_On_Leave desc;

-- What is the average number of leave days taken by its employees per department?
select j.jobdept,avg(l.leave_id) from jobdepartment j
join employee e
on e.job_id = j.job_id
join leaves l
on e.emp_id = l.emp_id
group by j.jobdept;

-- Which employees have taken the most leaves?
select e.firstname,e.lastname,count(l.leave_id) from leaves l
join employee e
on e.emp_id = l.emp_id
group by leave_id
order by count(leave_id) desc;

-- What is the total number of leave days taken company-wide?
select count(leave_id) as no_of_leaves_days from leaves;

-- How do leave days correlate with payroll amounts?
SELECT 
    p.payroll_ID,
    p.total_amount AS payroll_amount,
    l.leave_id,
    l.date AS leave_date
FROM payroll p
JOIN leaves l 
    ON p.leave_ID = l.leave_ID;

-- 5. PAYROLL AND COMPENSATION ANALYSIS

-- What is the total monthly payroll processed?
select year(date) year,month(date) month , sum(total_amount) total_monthly_payroll from payroll
group by year,month
order by year,month desc;

-- What is the average bonus given per department?
select j.jobdept,avg(s.bonus) as average_bonus from salarybonus s
join jobdepartment j
on s.job_id = j.job_id
group by j.jobdept
order by average_bonus desc;

-- Which department receives the highest total bonuses?
select j.jobdept,sum(s.bonus) total_bonus from jobdepartment j
join salarybonus s
on j.job_id = s.job_id
group by j.jobdept
order by total_bonus desc
limit 1;

-- What is the average value of total_amount after considering leave deductions?
select avg(total_amount) average_total_amount from payroll;





select * from jobdepartment;
select * from employee;
select * from leaves;
select * from salarybonus;
select * from payroll;
select * from qualification;

SHOW TABLES;