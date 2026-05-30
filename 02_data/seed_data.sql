-- ============================================================
-- FINANCIAL CUSTOMER ANALYTICS SYSTEM
-- File: 02_data/seed_data.sql
-- Description: Realistic seed data — branches, customers, accounts,
--              products, transactions, loans, repayments
-- ============================================================

USE financial_analytics;

-- ============================================================
-- 1. BRANCHES (10 branches across regions)
-- ============================================================
INSERT INTO branches (branch_name, city, state, region, manager_name, headcount, opened_date) VALUES
('Downtown Financial Centre', 'New York',     'NY', 'East',    'Sarah Mitchell',   45, '2015-03-01'),
('Midtown Business Hub',      'New York',     'NY', 'East',    'James Carter',     38, '2016-07-15'),
('West Coast HQ',             'Los Angeles',  'CA', 'West',    'Linda Zhao',       52, '2014-01-10'),
('Silicon Valley Branch',     'San Francisco','CA', 'West',    'David Kim',        30, '2017-05-20'),
('Chicago Central',           'Chicago',      'IL', 'Central', 'Robert Evans',     41, '2015-09-12'),
('Texas Financial Hub',       'Houston',      'TX', 'South',   'Maria Gonzalez',   35, '2016-11-08'),
('Atlanta Business Centre',   'Atlanta',      'GA', 'South',   'Thomas Brown',     28, '2018-02-14'),
('Phoenix Desert Branch',     'Phoenix',      'AZ', 'West',    'Emily Davis',      22, '2019-06-01'),
('Boston Academic District',  'Boston',       'MA', 'East',    'Michael Wilson',   33, '2016-04-25'),
('Seattle Tech Hub',          'Seattle',      'WA', 'West',    'Jessica Lee',      27, '2018-10-30');

-- ============================================================
-- 2. PRODUCTS (6 product types)
-- ============================================================
INSERT INTO products (product_name, product_type, interest_rate, monthly_fee, min_balance) VALUES
('Premium Savings Account',   'Savings',       3.50,  0.00,   500.00),
('Standard Checking Account', 'Checking',      0.50,  12.00,    0.00),
('Platinum Credit Card',      'Credit Card',  19.99, 25.00,     0.00),
('Gold Credit Card',          'Credit Card',  15.99, 15.00,     0.00),
('Home Mortgage',             'Mortgage',      4.25,  0.00,     0.00),
('Personal Loan',             'Personal Loan', 8.75,  0.00,     0.00),
('Business Investment Fund',  'Investment',    6.00,  50.00, 5000.00),
('Basic Savings Account',     'Savings',       1.50,  5.00,   100.00);

-- ============================================================
-- 3. CUSTOMERS (100 realistic customers)
-- ============================================================
INSERT INTO customers (first_name, last_name, email, phone, date_of_birth, gender, occupation, annual_income, city, state, segment, joined_date) VALUES
('James',     'Anderson',  'james.anderson@email.com',   '212-555-0101', '1985-03-15', 'Male',   'Software Engineer',    95000,  'New York',      'NY', 'Premium',  '2020-01-10'),
('Sarah',     'Thompson',  'sarah.thompson@email.com',   '212-555-0102', '1990-07-22', 'Female', 'Marketing Manager',    72000,  'New York',      'NY', 'Standard', '2020-02-14'),
('Michael',   'Garcia',    'michael.garcia@email.com',   '310-555-0103', '1978-11-05', 'Male',   'Financial Analyst',   110000,  'Los Angeles',   'CA', 'Premium',  '2020-01-25'),
('Emily',     'Martinez',  'emily.martinez@email.com',   '310-555-0104', '1995-04-18', 'Female', 'Graphic Designer',     55000,  'Los Angeles',   'CA', 'Standard', '2020-03-08'),
('David',     'Johnson',   'david.johnson@email.com',    '415-555-0105', '1982-09-30', 'Male',   'Product Manager',     125000,  'San Francisco', 'CA', 'Premium',  '2020-01-15'),
('Jessica',   'Williams',  'jessica.williams@email.com', '415-555-0106', '1993-12-11', 'Female', 'Data Scientist',       98000,  'San Francisco', 'CA', 'Premium',  '2020-04-20'),
('Robert',    'Brown',     'robert.brown@email.com',     '312-555-0107', '1975-06-25', 'Male',   'Accountant',           68000,  'Chicago',       'IL', 'Standard', '2020-02-05'),
('Linda',     'Davis',     'linda.davis@email.com',      '312-555-0108', '1988-02-14', 'Female', 'HR Manager',           74000,  'Chicago',       'IL', 'Standard', '2020-05-12'),
('Thomas',    'Wilson',    'thomas.wilson@email.com',    '713-555-0109', '1980-08-19', 'Male',   'Oil Engineer',        145000,  'Houston',       'TX', 'Premium',  '2020-03-22'),
('Patricia',  'Moore',     'patricia.moore@email.com',   '713-555-0110', '1992-05-07', 'Female', 'Nurse',                62000,  'Houston',       'TX', 'Standard', '2020-06-01'),
('Charles',   'Taylor',    'charles.taylor@email.com',   '404-555-0111', '1987-10-23', 'Male',   'Sales Manager',        80000,  'Atlanta',       'GA', 'Standard', '2020-04-10'),
('Barbara',   'Jackson',   'barbara.jackson@email.com',  '404-555-0112', '1979-01-17', 'Female', 'Lawyer',              135000,  'Atlanta',       'GA', 'Premium',  '2020-07-15'),
('Daniel',    'Harris',    'daniel.harris@email.com',    '602-555-0113', '1994-07-08', 'Male',   'Teacher',              48000,  'Phoenix',       'AZ', 'Basic',    '2020-05-28'),
('Susan',     'Martin',    'susan.martin@email.com',     '602-555-0114', '1983-03-29', 'Female', 'Retail Manager',       57000,  'Phoenix',       'AZ', 'Standard', '2020-08-03'),
('Paul',      'Thompson',  'paul.thompson@email.com',    '617-555-0115', '1976-12-04', 'Male',   'University Professor', 92000,  'Boston',        'MA', 'Premium',  '2020-06-18'),
('Nancy',     'White',     'nancy.white@email.com',      '617-555-0116', '1991-09-16', 'Female', 'Research Analyst',     76000,  'Boston',        'MA', 'Standard', '2020-09-22'),
('Mark',      'Lopez',     'mark.lopez@email.com',       '206-555-0117', '1986-04-11', 'Male',   'Cloud Architect',     118000,  'Seattle',       'WA', 'Premium',  '2020-07-07'),
('Dorothy',   'Lee',       'dorothy.lee@email.com',      '206-555-0118', '1997-11-28', 'Female', 'UX Designer',          65000,  'Seattle',       'WA', 'Standard', '2020-10-14'),
('Steven',    'Walker',    'steven.walker@email.com',    '212-555-0119', '1973-06-02', 'Male',   'Investment Banker',   200000,  'New York',      'NY', 'Premium',  '2020-08-25'),
('Sandra',    'Hall',      'sandra.hall@email.com',      '212-555-0120', '1989-02-20', 'Female', 'Event Planner',        53000,  'New York',      'NY', 'Basic',    '2020-11-09'),
('Kenneth',   'Allen',     'kenneth.allen@email.com',    '310-555-0121', '1984-08-13', 'Male',   'Real Estate Agent',    88000,  'Los Angeles',   'CA', 'Standard', '2021-01-05'),
('Betty',     'Young',     'betty.young@email.com',      '310-555-0122', '1996-05-25', 'Female', 'Social Media Manager',  48000, 'Los Angeles',   'CA', 'Basic',    '2021-02-18'),
('George',    'Hernandez', 'george.hernandez@email.com', '415-555-0123', '1981-10-07', 'Male',   'Mechanical Engineer',  96000,  'San Francisco', 'CA', 'Premium',  '2021-01-22'),
('Helen',     'King',      'helen.king@email.com',       '415-555-0124', '1994-03-14', 'Female', 'Pharmacist',           85000,  'San Francisco', 'CA', 'Standard', '2021-03-10'),
('Edward',    'Wright',    'edward.wright@email.com',    '312-555-0125', '1977-07-31', 'Male',   'Construction Manager', 78000,  'Chicago',       'IL', 'Standard', '2021-02-05'),
('Carol',     'Scott',     'carol.scott@email.com',      '312-555-0126', '1990-01-19', 'Female', 'Dietitian',            61000,  'Chicago',       'IL', 'Standard', '2021-04-12'),
('Brian',     'Green',     'brian.green@email.com',      '713-555-0127', '1985-12-08', 'Male',   'Petroleum Engineer',  130000,  'Houston',       'TX', 'Premium',  '2021-03-18'),
('Sharon',    'Adams',     'sharon.adams@email.com',     '713-555-0128', '1993-06-22', 'Female', 'Physical Therapist',   70000,  'Houston',       'TX', 'Standard', '2021-05-27'),
('Ronald',    'Baker',     'ronald.baker@email.com',     '404-555-0129', '1979-09-15', 'Male',   'Logistics Manager',    72000,  'Atlanta',       'GA', 'Standard', '2021-04-08'),
('Donna',     'Gonzalez',  'donna.gonzalez@email.com',   '404-555-0130', '1987-04-03', 'Female', 'Interior Designer',    58000,  'Atlanta',       'GA', 'Standard', '2021-06-15'),
('Anthony',   'Nelson',    'anthony.nelson@email.com',   '602-555-0131', '1982-11-27', 'Male',   'Dentist',             165000,  'Phoenix',       'AZ', 'Premium',  '2021-05-20'),
('Lisa',      'Carter',    'lisa.carter@email.com',      '602-555-0132', '1995-08-10', 'Female', 'Fitness Trainer',      42000,  'Phoenix',       'AZ', 'Basic',    '2021-07-03'),
('Kevin',     'Mitchell',  'kevin.mitchell@email.com',   '617-555-0133', '1976-03-22', 'Male',   'Surgeon',             280000,  'Boston',        'MA', 'Premium',  '2021-06-11'),
('Sharon',    'Perez',     'sharon.perez@email.com',     '617-555-0134', '1992-10-05', 'Female', 'Journalist',           52000,  'Boston',        'MA', 'Basic',    '2021-08-22'),
('Jason',     'Roberts',   'jason.roberts@email.com',    '206-555-0135', '1988-05-18', 'Male',   'DevOps Engineer',     108000,  'Seattle',       'WA', 'Premium',  '2021-07-14'),
('Ashley',    'Turner',    'ashley.turner@email.com',    '206-555-0136', '1999-02-28', 'Female', 'Intern',               32000,  'Seattle',       'WA', 'Basic',    '2021-09-05'),
('Gary',      'Phillips',  'gary.phillips@email.com',    '212-555-0137', '1974-08-09', 'Male',   'Portfolio Manager',   175000,  'New York',      'NY', 'Premium',  '2021-08-19'),
('Kimberly',  'Campbell',  'kimberly.campbell@email.com','212-555-0138', '1991-12-21', 'Female', 'Fashion Designer',     60000,  'New York',      'NY', 'Standard', '2021-10-07'),
('Eric',      'Parker',    'eric.parker@email.com',      '310-555-0139', '1983-04-14', 'Male',   'Film Director',        90000,  'Los Angeles',   'CA', 'Standard', '2021-09-23'),
('Amanda',    'Evans',     'amanda.evans@email.com',     '310-555-0140', '1997-07-06', 'Female', 'Barista',              28000,  'Los Angeles',   'CA', 'Basic',    '2021-11-14'),
('Justin',    'Edwards',   'justin.edwards@email.com',   '415-555-0141', '1980-01-30', 'Male',   'Venture Capitalist',  250000,  'San Francisco', 'CA', 'Premium',  '2021-10-18'),
('Melissa',   'Collins',   'melissa.collins@email.com',  '415-555-0142', '1993-09-12', 'Female', 'Biotech Researcher',   82000,  'San Francisco', 'CA', 'Standard', '2021-12-01'),
('Raymond',   'Stewart',   'raymond.stewart@email.com',  '312-555-0143', '1978-06-24', 'Male',   'Supply Chain Manager', 86000,  'Chicago',       'IL', 'Standard', '2022-01-10'),
('Rebecca',   'Morris',    'rebecca.morris@email.com',   '312-555-0144', '1989-03-07', 'Female', 'Architect',           100000,  'Chicago',       'IL', 'Premium',  '2022-02-22'),
('Gregory',   'Rogers',    'gregory.rogers@email.com',   '713-555-0145', '1985-10-19', 'Male',   'Geologist',            87000,  'Houston',       'TX', 'Standard', '2022-01-30'),
('Stephanie', 'Reed',      'stephanie.reed@email.com',   '713-555-0146', '1994-07-02', 'Female', 'Marketing Analyst',    63000,  'Houston',       'TX', 'Standard', '2022-03-15'),
('Frank',     'Cook',      'frank.cook@email.com',       '404-555-0147', '1971-02-14', 'Male',   'Restaurant Owner',     95000,  'Atlanta',       'GA', 'Standard', '2022-02-08'),
('Samantha',  'Morgan',    'samantha.morgan@email.com',  '404-555-0148', '1998-11-26', 'Female', 'Student',              18000,  'Atlanta',       'GA', 'Basic',    '2022-04-20'),
('Raymond',   'Bell',      'raymond.bell@email.com',     '602-555-0149', '1986-05-09', 'Male',   'Electrician',          68000,  'Phoenix',       'AZ', 'Standard', '2022-03-25'),
('Catherine', 'Murphy',    'catherine.murphy@email.com', '602-555-0150', '1990-08-21', 'Female', 'Veterinarian',         90000,  'Phoenix',       'AZ', 'Standard', '2022-05-12'),
('Patrick',   'Bailey',    'patrick.bailey@email.com',   '617-555-0151', '1977-12-03', 'Male',   'Civil Engineer',        82000, 'Boston',        'MA', 'Standard', '2022-04-07'),
('Janet',     'Rivera',    'janet.rivera@email.com',     '617-555-0152', '1995-04-15', 'Female', 'Occupational Therapist',67000, 'Boston',        'MA', 'Standard', '2022-06-18'),
('Walter',    'Cooper',    'walter.cooper@email.com',    '206-555-0153', '1981-09-27', 'Male',   'Software Architect',  135000,  'Seattle',       'WA', 'Premium',  '2022-05-22'),
('Virginia',  'Richardson','virginia.richardson@email.com','206-555-0154','1993-01-10','Female', 'Data Engineer',         95000,  'Seattle',       'WA', 'Premium',  '2022-07-05'),
('Harold',    'Cox',       'harold.cox@email.com',       '212-555-0155', '1968-07-23', 'Male',   'Retired Banker',        40000,  'New York',      'NY', 'Basic',    '2022-06-14'),
('Deborah',   'Howard',    'deborah.howard@email.com',   '212-555-0156', '1984-11-05', 'Female', 'Psychologist',          88000,  'New York',      'NY', 'Standard', '2022-08-28'),
('Henry',     'Ward',      'henry.ward@email.com',       '310-555-0157', '1990-03-18', 'Male',   'Actor',                 70000,  'Los Angeles',   'CA', 'Standard', '2022-07-19'),
('Carolyn',   'Torres',    'carolyn.torres@email.com',   '310-555-0158', '1996-10-30', 'Female', 'Makeup Artist',         38000,  'Los Angeles',   'CA', 'Basic',    '2022-09-11'),
('Arthur',    'Peterson',  'arthur.peterson@email.com',  '415-555-0159', '1979-06-12', 'Male',   'Hedge Fund Manager',  220000,  'San Francisco', 'CA', 'Premium',  '2022-08-04'),
('Martha',    'Gray',      'martha.gray@email.com',      '415-555-0160', '1992-02-24', 'Female', 'Environmental Scientist',74000, 'San Francisco', 'CA', 'Standard', '2022-10-17'),
('Ryan',      'Ramirez',   'ryan.ramirez@email.com',     '312-555-0161', '1987-08-06', 'Male',   'Financial Planner',     93000,  'Chicago',       'IL', 'Standard', '2022-09-08'),
('Amanda',    'James',     'amanda.james@email.com',     '312-555-0162', '1998-05-19', 'Female', 'Graduate Student',      22000,  'Chicago',       'IL', 'Basic',    '2022-11-30'),
('Dennis',    'Watson',    'dennis.watson@email.com',    '713-555-0163', '1975-01-31', 'Male',   'Offshore Driller',      95000,  'Houston',       'TX', 'Standard', '2022-10-15'),
('Julie',     'Brooks',    'julie.brooks@email.com',     '713-555-0164', '1991-09-22', 'Female', 'Speech Therapist',      66000,  'Houston',       'TX', 'Standard', '2023-01-08'),
('Larry',     'Kelly',     'larry.kelly@email.com',      '404-555-0165', '1983-04-04', 'Male',   'Pilot',                125000,  'Atlanta',       'GA', 'Premium',  '2023-02-20'),
('Helen',     'Sanders',   'helen.sanders@email.com',    '404-555-0166', '1997-12-16', 'Female', 'Flight Attendant',      52000,  'Atlanta',       'GA', 'Basic',    '2023-01-25'),
('Peter',     'Price',     'peter.price@email.com',      '602-555-0167', '1980-07-28', 'Male',   'IT Manager',           105000,  'Phoenix',       'AZ', 'Premium',  '2023-03-14'),
('Brenda',    'Bennett',   'brenda.bennett@email.com',   '602-555-0168', '1994-03-10', 'Female', 'Radiologist',          165000,  'Phoenix',       'AZ', 'Premium',  '2023-02-07'),
('Harold',    'Wood',      'harold.wood@email.com',      '617-555-0169', '1978-10-22', 'Male',   'Photographer',           55000,  'Boston',       'MA', 'Standard', '2023-04-19'),
('Donna',     'Barnes',    'donna.barnes@email.com',     '617-555-0170', '1989-06-04', 'Female', 'Nutritionist',           60000,  'Boston',       'MA', 'Standard', '2023-03-28'),
('Carl',      'Ross',      'carl.ross@email.com',        '206-555-0171', '1986-02-16', 'Male',   'Blockchain Developer',  115000,  'Seattle',      'WA', 'Premium',  '2023-05-10'),
('Catherine', 'Henderson', 'catherine.henderson@email.com','206-555-0172','1993-11-28','Female', 'AI Researcher',         105000,  'Seattle',      'WA', 'Premium',  '2023-04-22'),
('Wayne',     'Coleman',   'wayne.coleman@email.com',    '212-555-0173', '1971-08-10', 'Male',   'Business Owner',        140000,  'New York',     'NY', 'Premium',  '2023-06-03'),
('Alice',     'Jenkins',   'alice.jenkins@email.com',    '212-555-0174', '1999-04-22', 'Female', 'Freelancer',             35000,  'New York',     'NY', 'Basic',    '2023-05-15'),
('Roy',       'Perry',     'roy.perry@email.com',        '310-555-0175', '1984-01-05', 'Male',   'Music Producer',         80000,  'Los Angeles',  'CA', 'Standard', '2023-07-18'),
('Emma',      'Powell',    'emma.powell@email.com',      '310-555-0176', '1996-07-17', 'Female', 'YouTuber',               45000,  'Los Angeles',  'CA', 'Basic',    '2023-06-30'),
('Eugene',    'Long',      'eugene.long@email.com',      '415-555-0177', '1982-11-29', 'Male',   'Cybersecurity Expert',  122000,  'San Francisco','CA', 'Premium',  '2023-08-12'),
('Mildred',   'Patterson', 'mildred.patterson@email.com','415-555-0178', '1990-08-11', 'Female', 'Tax Attorney',           130000,  'San Francisco','CA', 'Premium',  '2023-07-24'),
('Ralph',     'Hughes',    'ralph.hughes@email.com',     '312-555-0179', '1977-05-23', 'Male',   'Warehouse Manager',       62000,  'Chicago',     'IL', 'Standard', '2023-09-05'),
('Phyllis',   'Flores',    'phyllis.flores@email.com',   '312-555-0180', '1988-02-05', 'Female', 'Dental Hygienist',        58000,  'Chicago',     'IL', 'Standard', '2023-08-17'),
('Jesse',     'Washington','jesse.washington@email.com', '713-555-0181', '1985-09-17', 'Male',   'Firefighter',             64000,  'Houston',     'TX', 'Standard', '2023-10-29'),
('Maria',     'Butler',    'maria.butler@email.com',     '713-555-0182', '1997-06-29', 'Female', 'Graphic Artist',          42000,  'Houston',     'TX', 'Basic',    '2023-09-20'),
('Harold',    'Simmons',   'harold.simmons@email.com',   '404-555-0183', '1980-03-11', 'Male',   'Police Officer',          68000,  'Atlanta',     'GA', 'Standard', '2023-11-12'),
('Shirley',   'Foster',    'shirley.foster@email.com',   '404-555-0184', '1992-12-23', 'Female', 'Midwife',                 72000,  'Atlanta',     'GA', 'Standard', '2023-10-04'),
('Philip',    'Gonzales',  'philip.gonzales@email.com',  '602-555-0185', '1983-07-05', 'Male',   'Solar Engineer',          88000,  'Phoenix',     'AZ', 'Standard', '2023-12-15'),
('Shirley',   'Bryant',    'shirley.bryant@email.com',   '602-555-0186', '1995-04-17', 'Female', 'Social Worker',           46000,  'Phoenix',     'AZ', 'Basic',    '2023-11-26'),
('Bobby',     'Alexander', 'bobby.alexander@email.com',  '617-555-0187', '1981-10-29', 'Male',   'Marine Biologist',        75000,  'Boston',      'MA', 'Standard', '2024-01-08'),
('Ruth',      'Russell',   'ruth.russell@email.com',     '617-555-0188', '1989-07-11', 'Female', 'Epidemiologist',          85000,  'Boston',      'MA', 'Standard', '2024-02-20'),
('Johnny',    'Griffin',   'johnny.griffin@email.com',   '206-555-0189', '1986-02-22', 'Male',   'Game Developer',         100000,  'Seattle',     'WA', 'Premium',  '2024-01-14'),
('Sara',      'Diaz',      'sara.diaz@email.com',        '206-555-0190', '1998-11-04', 'Female', 'Barista/Student',         20000,  'Seattle',     'WA', 'Basic',    '2024-03-25'),
('Billy',     'Hayes',     'billy.hayes@email.com',      '212-555-0191', '1974-08-16', 'Male',   'Real Estate Developer',  190000,  'New York',    'NY', 'Premium',  '2024-02-07'),
('Kathryn',   'Myers',     'kathryn.myers@email.com',    '212-555-0192', '1991-05-28', 'Female', 'Brand Strategist',        78000,  'New York',    'NY', 'Standard', '2024-04-18'),
('Bruce',     'Ford',      'bruce.ford@email.com',       '310-555-0193', '1979-12-10', 'Male',   'Sports Coach',            65000,  'Los Angeles', 'CA', 'Standard', '2024-03-01'),
('Frances',   'Hamilton',  'frances.hamilton@email.com', '310-555-0194', '1993-09-22', 'Female', 'Clinical Psychologist',   95000,  'Los Angeles', 'CA', 'Standard', '2024-05-14'),
('Eugene',    'Graham',    'eugene.graham@email.com',    '415-555-0195', '1987-06-04', 'Male',   'Quantitative Analyst',   145000,  'San Francisco','CA','Premium',  '2024-04-26'),
('Annie',     'Sullivan',  'annie.sullivan@email.com',   '415-555-0196', '1994-02-16', 'Female', 'Compliance Officer',      88000,  'San Francisco','CA','Standard', '2024-06-07'),
('Willie',    'Wallace',   'willie.wallace@email.com',   '312-555-0197', '1976-10-28', 'Male',   'Insurance Broker',        75000,  'Chicago',     'IL', 'Standard', '2024-05-20'),
('Lillian',   'Woods',     'lillian.woods@email.com',    '312-555-0198', '1988-07-10', 'Female', 'Occupational Therapist',  69000,  'Chicago',     'IL', 'Standard', '2024-07-02'),
('Aaron',     'Cole',      'aaron.cole@email.com',       '713-555-0199', '1984-04-22', 'Male',   'Petroleum Geologist',    115000,  'Houston',     'TX', 'Premium',  '2024-06-15'),
('Lois',      'West',      'lois.west@email.com',        '713-555-0200', '1996-01-04', 'Female', 'Paralegal',               52000,  'Houston',     'TX', 'Standard', '2024-08-27');

-- ============================================================
-- 4. ACCOUNTS (one per customer, mix of product types)
-- ============================================================
INSERT INTO accounts (customer_id, branch_id, product_id, account_number, balance, status, opened_date) VALUES
(1,  1, 1, 'ACC-10001', 45230.50,  'Active',  '2020-01-10'),
(2,  1, 2, 'ACC-10002', 3820.75,   'Active',  '2020-02-14'),
(3,  3, 1, 'ACC-10003', 87450.00,  'Active',  '2020-01-25'),
(4,  3, 8, 'ACC-10004', 1250.30,   'Active',  '2020-03-08'),
(5,  4, 7, 'ACC-10005', 215000.00, 'Active',  '2020-01-15'),
(6,  4, 1, 'ACC-10006', 62800.25,  'Active',  '2020-04-20'),
(7,  5, 2, 'ACC-10007', 5640.80,   'Active',  '2020-02-05'),
(8,  5, 2, 'ACC-10008', 9230.45,   'Active',  '2020-05-12'),
(9,  6, 7, 'ACC-10009', 325000.00, 'Active',  '2020-03-22'),
(10, 6, 8, 'ACC-10010', 2150.60,   'Active',  '2020-06-01'),
(11, 7, 2, 'ACC-10011', 7890.35,   'Active',  '2020-04-10'),
(12, 7, 1, 'ACC-10012', 95000.00,  'Active',  '2020-07-15'),
(13, 8, 8, 'ACC-10013', 890.20,    'Dormant', '2020-05-28'),
(14, 8, 2, 'ACC-10014', 4320.90,   'Active',  '2020-08-03'),
(15, 9, 1, 'ACC-10015', 58700.00,  'Active',  '2020-06-18'),
(16, 9, 2, 'ACC-10016', 12400.55,  'Active',  '2020-09-22'),
(17, 10, 1, 'ACC-10017', 78500.00, 'Active',  '2020-07-07'),
(18, 10, 8, 'ACC-10018', 1680.40,  'Active',  '2020-10-14'),
(19, 1, 7, 'ACC-10019', 450000.00, 'Active',  '2020-08-25'),
(20, 1, 8, 'ACC-10020', 650.15,    'Dormant', '2020-11-09'),
(21, 3, 2, 'ACC-10021', 8920.70,   'Active',  '2021-01-05'),
(22, 3, 8, 'ACC-10022', 420.85,    'Active',  '2021-02-18'),
(23, 4, 1, 'ACC-10023', 72300.00,  'Active',  '2021-01-22'),
(24, 4, 2, 'ACC-10024', 15600.30,  'Active',  '2021-03-10'),
(25, 5, 2, 'ACC-10025', 6780.95,   'Active',  '2021-02-05'),
(26, 5, 8, 'ACC-10026', 2340.60,   'Active',  '2021-04-12'),
(27, 6, 1, 'ACC-10027', 98500.00,  'Active',  '2021-03-18'),
(28, 6, 2, 'ACC-10028', 11200.45,  'Active',  '2021-05-27'),
(29, 7, 2, 'ACC-10029', 9870.20,   'Active',  '2021-04-08'),
(30, 7, 8, 'ACC-10030', 3450.75,   'Active',  '2021-06-15'),
(31, 8, 1, 'ACC-10031', 125000.00, 'Active',  '2021-05-20'),
(32, 8, 8, 'ACC-10032', 780.30,    'Active',  '2021-07-03'),
(33, 9, 1, 'ACC-10033', 210000.00, 'Active',  '2021-06-11'),
(34, 9, 8, 'ACC-10034', 920.65,    'Dormant', '2021-08-22'),
(35, 10, 7, 'ACC-10035', 185000.00,'Active',  '2021-07-14'),
(36, 10, 8, 'ACC-10036', 340.20,   'Active',  '2021-09-05'),
(37, 1, 7, 'ACC-10037', 380000.00, 'Active',  '2021-08-19'),
(38, 1, 2, 'ACC-10038', 7840.55,   'Active',  '2021-10-07'),
(39, 3, 2, 'ACC-10039', 13200.80,  'Active',  '2021-09-23'),
(40, 3, 8, 'ACC-10040', 510.45,    'Dormant', '2021-11-14'),
(41, 4, 7, 'ACC-10041', 620000.00, 'Active',  '2021-10-18'),
(42, 4, 1, 'ACC-10042', 54800.00,  'Active',  '2021-12-01'),
(43, 5, 2, 'ACC-10043', 18700.35,  'Active',  '2022-01-10'),
(44, 5, 1, 'ACC-10044', 72600.00,  'Active',  '2022-02-22'),
(45, 6, 2, 'ACC-10045', 14300.60,  'Active',  '2022-01-30'),
(46, 6, 2, 'ACC-10046', 9800.25,   'Active',  '2022-03-15'),
(47, 7, 2, 'ACC-10047', 21500.70,  'Active',  '2022-02-08'),
(48, 7, 8, 'ACC-10048', 280.90,    'Active',  '2022-04-20'),
(49, 8, 2, 'ACC-10049', 8640.45,   'Active',  '2022-03-25'),
(50, 8, 2, 'ACC-10050', 16400.80,  'Active',  '2022-05-12'),
(51, 9, 2, 'ACC-10051', 11300.35,  'Active',  '2022-04-07'),
(52, 9, 2, 'ACC-10052', 7200.60,   'Active',  '2022-06-18'),
(53, 10, 7, 'ACC-10053', 260000.00,'Active',  '2022-05-22'),
(54, 10, 1, 'ACC-10054', 48900.00, 'Active',  '2022-07-05'),
(55, 1, 8, 'ACC-10055', 920.15,    'Active',  '2022-06-14'),
(56, 1, 2, 'ACC-10056', 19700.40,  'Active',  '2022-08-28'),
(57, 3, 2, 'ACC-10057', 14800.65,  'Active',  '2022-07-19'),
(58, 3, 8, 'ACC-10058', 430.20,    'Active',  '2022-09-11'),
(59, 4, 7, 'ACC-10059', 510000.00, 'Active',  '2022-08-04'),
(60, 4, 2, 'ACC-10060', 22600.45,  'Active',  '2022-10-17'),
(61, 5, 2, 'ACC-10061', 17900.70,  'Active',  '2022-09-08'),
(62, 5, 8, 'ACC-10062', 360.85,    'Active',  '2022-11-30'),
(63, 6, 2, 'ACC-10063', 12400.30,  'Active',  '2022-10-15'),
(64, 6, 2, 'ACC-10064', 8500.55,   'Active',  '2023-01-08'),
(65, 7, 1, 'ACC-10065', 94000.00,  'Active',  '2023-02-20'),
(66, 7, 8, 'ACC-10066', 670.40,    'Active',  '2023-01-25'),
(67, 8, 7, 'ACC-10067', 175000.00, 'Active',  '2023-03-14'),
(68, 8, 1, 'ACC-10068', 128000.00, 'Active',  '2023-02-07'),
(69, 9, 2, 'ACC-10069', 10200.65,  'Active',  '2023-04-19'),
(70, 9, 2, 'ACC-10070', 13700.80,  'Active',  '2023-03-28'),
(71, 10, 1, 'ACC-10071', 82500.00, 'Active',  '2023-05-10'),
(72, 10, 7, 'ACC-10072', 298000.00,'Active',  '2023-04-22'),
(73, 1, 7, 'ACC-10073', 490000.00, 'Active',  '2023-06-03'),
(74, 1, 8, 'ACC-10074', 540.35,    'Active',  '2023-05-15'),
(75, 3, 2, 'ACC-10075', 15800.60,  'Active',  '2023-07-18'),
(76, 3, 8, 'ACC-10076', 290.75,    'Active',  '2023-06-30'),
(77, 4, 1, 'ACC-10077', 92000.00,  'Active',  '2023-08-12'),
(78, 4, 1, 'ACC-10078', 108000.00, 'Active',  '2023-07-24'),
(79, 5, 2, 'ACC-10079', 9800.40,   'Active',  '2023-09-05'),
(80, 5, 2, 'ACC-10080', 14200.55,  'Active',  '2023-08-17'),
(81, 6, 2, 'ACC-10081', 7600.70,   'Active',  '2023-10-29'),
(82, 6, 8, 'ACC-10082', 460.85,    'Active',  '2023-09-20'),
(83, 7, 2, 'ACC-10083', 18300.30,  'Active',  '2023-11-12'),
(84, 7, 2, 'ACC-10084', 11900.45,  'Active',  '2023-10-04'),
(85, 8, 2, 'ACC-10085', 23500.60,  'Active',  '2023-12-15'),
(86, 8, 8, 'ACC-10086', 380.75,    'Active',  '2023-11-26'),
(87, 9, 2, 'ACC-10087', 16700.40,  'Active',  '2024-01-08'),
(88, 9, 2, 'ACC-10088', 21300.55,  'Active',  '2024-02-20'),
(89, 10, 1, 'ACC-10089', 78900.00, 'Active',  '2024-01-14'),
(90, 10, 8, 'ACC-10090', 520.30,   'Active',  '2024-03-25'),
(91, 1, 7, 'ACC-10091', 720000.00, 'Active',  '2024-02-07'),
(92, 1, 2, 'ACC-10092', 19800.45,  'Active',  '2024-04-18'),
(93, 3, 2, 'ACC-10093', 13500.60,  'Active',  '2024-03-01'),
(94, 3, 2, 'ACC-10094', 24700.75,  'Active',  '2024-05-14'),
(95, 4, 7, 'ACC-10095', 580000.00, 'Active',  '2024-04-26'),
(96, 4, 2, 'ACC-10096', 17200.40,  'Active',  '2024-06-07'),
(97, 5, 2, 'ACC-10097', 11800.55,  'Active',  '2024-05-20'),
(98, 5, 2, 'ACC-10098', 15400.70,  'Active',  '2024-07-02'),
(99, 6, 7, 'ACC-10099', 345000.00, 'Active',  '2024-06-15'),
(100,6, 2, 'ACC-10100', 9200.85,   'Active',  '2024-08-27');

-- ============================================================
-- 5. TRANSACTIONS (large realistic dataset ~500+ rows via procedure)
-- ============================================================

-- Helper procedure to generate transactions
DELIMITER //
CREATE PROCEDURE GenerateTransactions()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE acc_id INT;
    DECLARE cust_id INT;
    DECLARE txn_amount DECIMAL(15,2);
    DECLARE txn_type VARCHAR(20);
    DECLARE txn_date DATETIME;
    DECLARE cat VARCHAR(50);
    DECLARE types_arr VARCHAR(200) DEFAULT 'Deposit,Withdrawal,Payment,Transfer,Fee';
    DECLARE cats_arr  VARCHAR(500) DEFAULT 'Groceries,Utilities,Dining,Entertainment,Healthcare,Travel,Shopping,Education,Insurance,Fuel';

    WHILE i <= 600 DO
        SET acc_id  = (SELECT account_id FROM accounts ORDER BY RAND() LIMIT 1);
        SET cust_id = (SELECT customer_id FROM accounts WHERE account_id = acc_id);
        SET txn_amount = ROUND(RAND() * 4900 + 100, 2);
        SET txn_type = ELT(FLOOR(RAND()*5)+1, 'Deposit','Withdrawal','Payment','Transfer','Fee');
        SET cat      = ELT(FLOOR(RAND()*10)+1,'Groceries','Utilities','Dining','Entertainment','Healthcare','Travel','Shopping','Education','Insurance','Fuel');
        SET txn_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*1460) DAY);

        -- Occasionally insert a large transaction to trigger alerts
        IF i MOD 30 = 0 THEN
            SET txn_amount = ROUND(RAND() * 40000 + 10001, 2);
        END IF;

        INSERT INTO transactions (account_id, customer_id, transaction_type, amount, merchant_category, description, transaction_date, status)
        VALUES (acc_id, cust_id, txn_type, txn_amount, cat,
                CONCAT(txn_type, ' - ', cat), txn_date, 'Completed');

        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL GenerateTransactions();
DROP PROCEDURE GenerateTransactions;

-- ============================================================
-- 6. LOANS (30 loans across customers)
-- ============================================================
INSERT INTO loans (customer_id, branch_id, loan_type, principal_amount, interest_rate, term_months, monthly_payment, outstanding_balance, disbursement_date, maturity_date, status) VALUES
(1,  1,  'Personal',  25000,  8.75, 36,  793.45, 12400.50,  '2022-03-01', '2025-03-01', 'Active'),
(3,  3,  'Mortgage', 450000,  4.25, 360, 2214.56, 428000.00, '2020-06-01', '2050-06-01', 'Active'),
(5,  4,  'Business', 150000,  7.50, 60,  3002.88, 98000.00,  '2021-04-01', '2026-04-01', 'Active'),
(7,  5,  'Auto',     32000,   5.99, 48,  751.58,  14200.00,  '2022-09-01', '2026-09-01', 'Active'),
(9,  6,  'Mortgage', 580000,  3.95, 360, 2741.23, 565000.00, '2020-10-01', '2050-10-01', 'Active'),
(12, 7,  'Personal', 50000,   9.25, 48,  1249.72, 28600.00,  '2021-07-01', '2025-07-01', 'Active'),
(15, 9,  'Business', 200000,  7.00, 84,  3048.73, 165000.00, '2020-11-01', '2027-11-01', 'Active'),
(17, 10, 'Mortgage', 380000,  4.50, 360, 1925.68, 372000.00, '2021-01-01', '2051-01-01', 'Active'),
(19, 1,  'Personal', 80000,   8.00, 60,  1622.29, 52000.00,  '2021-05-01', '2026-05-01', 'Active'),
(23, 4,  'Auto',     45000,   6.25, 60,  872.95,  31200.00,  '2021-09-01', '2026-09-01', 'Active'),
(27, 6,  'Personal', 35000,   9.50, 36,  1117.55, 8900.00,   '2022-01-01', '2025-01-01', 'Delinquent'),
(31, 8,  'Mortgage', 290000,  4.75, 360, 1513.32, 285000.00, '2022-03-01', '2052-03-01', 'Active'),
(33, 9,  'Business', 500000,  6.75, 120, 5716.87, 480000.00, '2022-08-01', '2032-08-01', 'Active'),
(35, 10, 'Mortgage', 410000,  4.25, 360, 2017.58, 406000.00, '2022-05-01', '2052-05-01', 'Active'),
(37, 1,  'Personal', 60000,   8.50, 48,  1487.48, 22400.00,  '2022-10-01', '2026-10-01', 'Active'),
(41, 4,  'Business', 750000,  7.25, 120, 8769.42, 730000.00, '2022-11-01', '2032-11-01', 'Active'),
(44, 5,  'Personal', 28000,   9.00, 36,  890.28,  5200.00,   '2022-04-01', '2025-04-01', 'Active'),
(47, 7,  'Auto',     38000,   6.50, 60,  741.36,  26800.00,  '2023-01-01', '2028-01-01', 'Active'),
(53, 10, 'Mortgage', 520000,  4.00, 360, 2483.84, 516000.00, '2022-12-01', '2052-12-01', 'Active'),
(56, 1,  'Personal', 22000,   9.75, 24,  1011.58, 3400.00,   '2023-02-01', '2025-02-01', 'Active'),
(59, 4,  'Business', 900000,  6.90, 120, 10429.18, 890000.00,'2023-06-01', '2033-06-01', 'Active'),
(65, 7,  'Mortgage', 320000,  4.60, 360, 1640.84, 318000.00, '2023-04-01', '2053-04-01', 'Active'),
(67, 8,  'Business', 180000,  7.10, 84,  2784.52, 175000.00, '2023-07-01', '2030-07-01', 'Active'),
(68, 8,  'Mortgage', 410000,  4.30, 360, 2033.85, 408000.00, '2023-08-01', '2053-08-01', 'Active'),
(71, 10, 'Personal', 42000,   8.90, 48,  1049.67, 36800.00,  '2023-09-01', '2027-09-01', 'Active'),
(72, 10, 'Business', 650000,  6.80, 120, 7484.75, 645000.00, '2023-10-01', '2033-10-01', 'Active'),
(27, 6,  'Auto',     28000,   7.20, 48,  674.59,  24100.00,  '2024-01-01', '2028-01-01', 'Active'),
(77, 4,  'Personal', 55000,   8.60, 60,  1130.48, 52000.00,  '2024-02-01', '2029-02-01', 'Active'),
(91, 1,  'Business',1200000,  6.50, 120, 13587.31,1195000.00,'2024-04-01', '2034-04-01', 'Active'),
(99, 6,  'Mortgage', 480000,  4.15, 360, 2330.17, 479000.00, '2024-07-01', '2054-07-01', 'Active');

-- ============================================================
-- 7. REPAYMENTS (monthly payments for active loans)
-- ============================================================
INSERT INTO repayments (loan_id, customer_id, amount_paid, payment_date, payment_method, is_on_time, days_late) VALUES
(1,  1,  793.45, '2022-04-01', 'Direct Debit', TRUE,  0),
(1,  1,  793.45, '2022-05-01', 'Direct Debit', TRUE,  0),
(1,  1,  793.45, '2022-06-01', 'Direct Debit', TRUE,  0),
(1,  1,  793.45, '2022-07-01', 'Direct Debit', FALSE, 5),
(1,  1,  793.45, '2022-08-01', 'Direct Debit', TRUE,  0),
(1,  1,  793.45, '2022-09-01', 'Direct Debit', TRUE,  0),
(2,  3,  2214.56,'2020-07-01', 'Bank Transfer', TRUE, 0),
(2,  3,  2214.56,'2020-08-01', 'Bank Transfer', TRUE, 0),
(2,  3,  2214.56,'2020-09-01', 'Bank Transfer', TRUE, 0),
(2,  3,  2214.56,'2020-10-01', 'Bank Transfer', TRUE, 0),
(2,  3,  2214.56,'2020-11-01', 'Bank Transfer', TRUE, 0),
(3,  5,  3002.88,'2021-05-01', 'Direct Debit', TRUE,  0),
(3,  5,  3002.88,'2021-06-01', 'Direct Debit', TRUE,  0),
(3,  5,  3002.88,'2021-07-01', 'Direct Debit', FALSE, 12),
(3,  5,  3002.88,'2021-08-01', 'Direct Debit', TRUE,  0),
(4,  7,  751.58, '2022-10-01', 'Direct Debit', TRUE,  0),
(4,  7,  751.58, '2022-11-01', 'Direct Debit', TRUE,  0),
(4,  7,  751.58, '2022-12-01', 'Direct Debit', FALSE, 8),
(4,  7,  751.58, '2023-01-01', 'Direct Debit', TRUE,  0),
(5,  9,  2741.23,'2020-11-01', 'Bank Transfer', TRUE, 0),
(5,  9,  2741.23,'2020-12-01', 'Bank Transfer', TRUE, 0),
(5,  9,  2741.23,'2021-01-01', 'Bank Transfer', TRUE, 0),
(6,  12, 1249.72,'2021-08-01', 'Direct Debit', TRUE,  0),
(6,  12, 1249.72,'2021-09-01', 'Direct Debit', TRUE,  0),
(6,  12, 1249.72,'2021-10-01', 'Direct Debit', FALSE, 3),
(7,  15, 3048.73,'2020-12-01', 'Bank Transfer', TRUE, 0),
(7,  15, 3048.73,'2021-01-01', 'Bank Transfer', TRUE, 0),
(8,  17, 1925.68,'2021-02-01', 'Direct Debit', TRUE,  0),
(8,  17, 1925.68,'2021-03-01', 'Direct Debit', TRUE,  0),
(9,  19, 1622.29,'2021-06-01', 'Bank Transfer', TRUE, 0),
(9,  19, 1622.29,'2021-07-01', 'Bank Transfer', FALSE,15),
(10, 23, 872.95, '2021-10-01', 'Direct Debit', TRUE,  0),
(10, 23, 872.95, '2021-11-01', 'Direct Debit', TRUE,  0),
(11, 27, 1117.55,'2022-02-01', 'Cash',          FALSE, 22),
(11, 27, 1117.55,'2022-03-01', 'Cash',          FALSE, 18),
(11, 27, 1117.55,'2022-04-01', 'Cash',          FALSE, 30),
(12, 31, 1513.32,'2022-04-01', 'Direct Debit', TRUE,  0),
(12, 31, 1513.32,'2022-05-01', 'Direct Debit', TRUE,  0),
(13, 33, 5716.87,'2022-09-01', 'Bank Transfer', TRUE, 0),
(13, 33, 5716.87,'2022-10-01', 'Bank Transfer', TRUE, 0),
(14, 35, 2017.58,'2022-06-01', 'Direct Debit', TRUE,  0),
(14, 35, 2017.58,'2022-07-01', 'Direct Debit', TRUE,  0),
(15, 37, 1487.48,'2022-11-01', 'Direct Debit', TRUE,  0),
(15, 37, 1487.48,'2022-12-01', 'Direct Debit', FALSE,  7),
(16, 41, 8769.42,'2022-12-01', 'Bank Transfer', TRUE, 0),
(16, 41, 8769.42,'2023-01-01', 'Bank Transfer', TRUE, 0),
(17, 44, 890.28, '2022-05-01', 'Direct Debit', TRUE,  0),
(17, 44, 890.28, '2022-06-01', 'Direct Debit', TRUE,  0),
(18, 47, 741.36, '2023-02-01', 'Direct Debit', TRUE,  0),
(18, 47, 741.36, '2023-03-01', 'Direct Debit', TRUE,  0),
(19, 53, 2483.84,'2023-01-01', 'Bank Transfer', TRUE, 0),
(19, 53, 2483.84,'2023-02-01', 'Bank Transfer', TRUE, 0),
(20, 56, 1011.58,'2023-03-01', 'Direct Debit', TRUE,  0),
(20, 56, 1011.58,'2023-04-01', 'Direct Debit', TRUE,  0);

SELECT 'Seed data loaded successfully!' AS Status;
SELECT 'Branches'     AS TableName, COUNT(*) AS RecordCount FROM branches    UNION ALL
SELECT 'Products',     COUNT(*) FROM products    UNION ALL
SELECT 'Customers',    COUNT(*) FROM customers   UNION ALL
SELECT 'Accounts',     COUNT(*) FROM accounts    UNION ALL
SELECT 'Transactions', COUNT(*) FROM transactions UNION ALL
SELECT 'Loans',        COUNT(*) FROM loans       UNION ALL
SELECT 'Repayments',   COUNT(*) FROM repayments;
