-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 26, 2018 at 08:53 AM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `banking`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `AccountNo` int auto_increment PRIMARY  KEY ,
  `Balance` double DEFAULT 0,
  `BranchID` int,
  `AccountType` enum('SavingAccount',' CurrentAccount') DEFAULT NULL,
  `PlanID` int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `account`
--

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `atmID` varchar(30) NOT NULL,
  `BranchID` int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `atmtransaction`
--

CREATE TABLE `atmtransaction` (
  `TransactionID` varchar(30) NOT NULL,
  `AccountNo` int DEFAULT NULL,
  `atmID` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `BranchID` int auto_increment primary key,
  `BranchType` enum('Head Office','Area Branch') DEFAULT NULL,
  `BranchName` varchar(30) DEFAULT NULL,
  `BranchCity` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `branch`
--

insert into `branch` (`BranchType`,`BranchName`,`BranchCity`) VALUES
('Head Office','Jaffna','Jaffna'),
('Area Branch','Nallur','Jaffna'),
('Head Office','Mankulam','Vavuniya'),
('Area Branch','Kaithadi','Jaffna'),
('Head Branch','Kobai','Trinco'),
('Area Branch','Kokuvil','Baticola');
-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` int AUTO_INCREMENT primary key,
  `CustomerName` varchar(30) DEFAULT NULL,
  `CustomerAddress` varchar(30) DEFAULT NULL,
  `DateOfBirth` DATE DEFAULT  NULL,
  `NIC` varchar(30) DEFAULT  NULL,
  `CustomerEmail` varchar(30) DEFAULT NULL,
  `CustomerPhoneNo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `customer_account`
--

CREATE TABLE `customer_account` (
  `CustomerID` int NOT NULL,
  `AccountNo` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmployeeID` varchar(30) NOT NULL,
  `BranchID` int,
  `EmpName` varchar(30) DEFAULT NULL,
  `EmpAddress` varchar(30) DEFAULT NULL,
  `EmpEmail` varchar(30) DEFAULT NULL,
  `EmpPhoneNo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee`
--


-- --------------------------------------------------------

--
-- Table structure for table `fdplan`
--

CREATE TABLE `fdplan` (
  `FDPlanID` varchar(30) NOT NULL,
  `InterestRate` double DEFAULT NULL,
  `Period` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fixeddeposit`
--

CREATE TABLE `fixeddeposit` (
  `FixedID` varchar(30) NOT NULL,
  `SavingNo` int,
  `FDAmount` varchar(30) DEFAULT NULL,
  `InterestRate` double DEFAULT NULL,
  `OpeningDate` date DEFAULT NULL,
  `FDPlanID` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lateloanreport`
--

CREATE TABLE `lateloanreport` (
  `ReportID` varchar(30) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `SettlementID` int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loan`
--

CREATE TABLE `loan` (
  `LoanID` int auto_increment primary key,
  `AccountNo` int DEFAULT NULL,
  `LoanType` enum('Personal Loan','Business Loan') DEFAULT NULL,
  `LoanAmount` float(30,2) DEFAULT NULL,
  `InterestRate` float(10,2) DEFAULT NULL,
   `MonthlyAmount` float(10,2) DEFAULT 0,
  `InstallmentRemaining` int DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loanapplications`
--

CREATE TABLE `loanapplications` (
  `ApplicationID` int(11) NOT NULL,
  `LoanType` enum('Personal Loan','Business Loan') DEFAULT NULL,
  `AccountNo` int,
  `EmployeeID` varchar(30) DEFAULT NULL,
  `RepayYears` int(4) DEFAULT NULL,
  `Amount` float(30,2) DEFAULT NULL,
  `Approved` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loanapplications`
--



--
-- Triggers `loanapplications`
--
DELIMITER $$
CREATE TRIGGER `checkApproved` AFTER UPDATE ON `loanapplications` FOR EACH ROW BEGIN
          if (NEW.Approved=1) THEN 
             insert into loan (AccountNo,LoanType,LoanAmount,InterestRate,MonthlyAmount,InstallmentRemaining)
             values (new.AccountNo,new.LoanType,new.Amount,0.12,(new.amount+ new.amount*0.12*new.RepayYears*12)/(new.RepayYears*12),new.RepayYears*12);
          END IF;
        END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loaninstallment`
--


--
-- Dumping data for table `loaninstallment`
--



-- --------------------------------------------------------

--
-- Table structure for table `loansettlement`
--

CREATE TABLE `loansettlement` (
  `SettlementID` int auto_increment primary key,
  `LoanID` int,
  `DateTime` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `PaidOnTime` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `Type` enum('Employee','Customer','Manager') DEFAULT NULL,
  `Username` varchar(30) NOT NULL,
  `Password` varchar(30) DEFAULT NULL,
  `BankID` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `manager`
--

CREATE TABLE `manager` (
  `EmployeeID` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `onlineloan`
--

CREATE TABLE `onlineloan` (
  `LoanID` int ,
  `FixedID` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `onlinetransaction`
--

CREATE TABLE `onlinetransaction` (
  `TransactionID` varchar(30) NOT NULL,
  `SenderAccNo` varchar(30) DEFAULT NULL,
  `RecieverAccNo` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `onlinetransaction`
--

INSERT INTO `onlinetransaction` (`TransactionID`, `SenderAccNo`, `RecieverAccNo`) VALUES
('2', '160001', '160002'),
('3', '160001', '160002'),
('4', '160001', '160002'),
('5', '160001', '160002'),
('6', '160001', '160002'),
('7', '160001', '160002'),
('8', '160001', '160002');

-- --------------------------------------------------------

--
-- Table structure for table `savingaccount`
--

CREATE TABLE `savingaccount` (
  `NoOfWithdrawals` int(11) DEFAULT NULL,
  `AccountNo` int ,
  `PlanID` int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `savingplan`
--

CREATE TABLE `savingplan` (
  `PlanID` int auto_increment primary key,
  `Category` varchar(30) DEFAULT  NULL,
  `InterestRate` double DEFAULT NULL,
  `MinimumAmount` int(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `savingplan`
--

insert into `savingplan` (`Category`,`InterestRate`,`MinimumAmount`) VALUES
('Children',12,0),
('Teen',11,500),
('Adult(18+)',10,1000),
('Senior(60+)',13,1000);
-- --------------------------------------------------------

--
-- Table structure for table `transactionreport`
--

CREATE TABLE `transactionreport` (
  `ReportID` varchar(30) NOT NULL,
  `Date` datetime NOT NULL,
  `TotalWidrawal` double DEFAULT NULL,
  `TotalDeposit` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `TransactionID` varchar(30) NOT NULL,
  `Amount` float(30,2) DEFAULT NULL,
  `Date_Time` datetime DEFAULT NULL,
  `Type` enum('Online','ATM') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`TransactionID`, `Amount`, `Date_Time`, `Type`) VALUES
('1', 50.00, '2018-11-08 01:37:25', 'Online'),
('2', 50.00, '2018-11-08 01:46:35', 'Online'),
('3', 50.00, '2018-11-08 01:53:39', 'Online'),
('4', 100.00, '2018-11-08 02:48:38', 'Online'),
('5', 1.00, '2018-11-08 10:47:20', 'Online'),
('6', 50.00, '2018-11-08 10:48:09', 'Online'),
('7', 100.00, '2018-11-08 10:49:30', 'Online'),
('8', 50.00, '2018-11-08 10:51:56', 'Online');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD KEY `BranchID` (`BranchID`),
  ADD KEY `PlanID` (`PlanID`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`),
  ADD KEY `BranchID` (`BranchID`);

--
-- Indexes for table `atmtransaction`
--
ALTER TABLE `atmtransaction`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `atmID` (`atmID`);

--
-- Indexes for table `branch`


--
-- Indexes for table `customer`


--
-- Indexes for table `customer_account`
--
ALTER TABLE `customer_account`
  ADD PRIMARY KEY (`CustomerID`,`AccountNo`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD KEY `BranchID` (`BranchID`);

--
-- Indexes for table `fdplan`
--
ALTER TABLE `fdplan`
  ADD PRIMARY KEY (`FDPlanID`);

--
-- Indexes for table `fixeddeposit`
--
ALTER TABLE `fixeddeposit`
  ADD PRIMARY KEY (`FixedID`),
  ADD KEY `SavingNo` (`SavingNo`),
  ADD KEY `FDPlanID` (`FDPlanID`);

--
-- Indexes for table `lateloanreport`
--
ALTER TABLE `lateloanreport`
  ADD KEY `SettlementID` (`SettlementID`);

--
-- Indexes for table `loan`
--
ALTER TABLE `loan`
  ADD KEY `AccountNo` (`AccountNo`);


--
-- Indexes for table `loanapplications`
--
ALTER TABLE `loanapplications`
  ADD PRIMARY KEY (`ApplicationID`),
  ADD KEY `AccountNo` (`AccountNo`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `loaninstallment`
--


--
-- Indexes for table `loansettlement`
--
ALTER TABLE `loansettlement`
  ADD KEY `LoanID` (`LoanID`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`Username`);

--
-- Indexes for table `manager`
--
ALTER TABLE `manager`
  ADD PRIMARY KEY (`EmployeeID`);

--
-- Indexes for table `onlineloan`
--
ALTER TABLE `onlineloan`
  ADD PRIMARY KEY (`LoanID`);

--
-- Indexes for table `onlinetransaction`
--
ALTER TABLE `onlinetransaction`
  ADD PRIMARY KEY (`TransactionID`);

--
-- Indexes for table `savingaccount`
--
ALTER TABLE `savingaccount`
  ADD PRIMARY KEY (`AccountNo`),
  ADD KEY `PlanID` (`PlanID`);

--
-- Indexes for table `savingplan`
--

--
-- Indexes for table `transactionreport`
--
ALTER TABLE `transactionreport`
  ADD PRIMARY KEY (`ReportID`,`Date`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`TransactionID`);

--
-- AUTO_INCREMENT for dumped tables
--

--


--
-- AUTO_INCREMENT for table `loanapplications`
--
ALTER TABLE `loanapplications`
  MODIFY `ApplicationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--


--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`PlanID`) REFERENCES `savingplan` (`PlanID`),
  ADD CONSTRAINT `account_ibfk_2` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`);

--
-- Constraints for table `atm`
--
ALTER TABLE `atm`
  ADD CONSTRAINT `atm_ibfk_1` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`);

--
-- Constraints for table `atmtransaction`
--
ALTER TABLE `atmtransaction`
  ADD CONSTRAINT `atmtransaction_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transactions` (`TransactionID`),
  ADD CONSTRAINT `atmtransaction_ibfk_2` FOREIGN KEY (`atmID`) REFERENCES `atm` (`atmID`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`BranchID`) REFERENCES `branch` (`BranchID`);

--
-- Constraints for table `fixeddeposit`
--
ALTER TABLE `fixeddeposit`
  ADD CONSTRAINT `fixeddeposit_ibfk_1` FOREIGN KEY (`SavingNo`) REFERENCES `savingaccount` (`AccountNo`),
  ADD CONSTRAINT `fixeddeposit_ibfk_2` FOREIGN KEY (`FDPlanID`) REFERENCES `fdplan` (`FDPlanID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lateloanreport`
--
ALTER TABLE `lateloanreport`
  ADD CONSTRAINT `lateloanreport_ibfk_1` FOREIGN KEY (`SettlementID`) REFERENCES `loansettlement` (`SettlementID`);

--
-- Constraints for table `loan`
--
ALTER TABLE `loan`
  ADD CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`AccountNo`) REFERENCES `account` (`AccountNo`);


--
-- Constraints for table `loanapplications`
--
ALTER TABLE `loanapplications`
  ADD CONSTRAINT `loanapplications_ibfk_1` FOREIGN KEY (`AccountNo`) REFERENCES `account` (`AccountNo`),
  ADD CONSTRAINT `loanapplications_ibfk_2` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`);

--
-- Constraints for table `loansettlement`
--
ALTER TABLE `loansettlement`
  ADD CONSTRAINT `loansettlement_ibfk_1` FOREIGN KEY (`LoanID`) REFERENCES `loan` (`LoanID`);

--
-- Constraints for table `manager`
--
ALTER TABLE `manager`
  ADD CONSTRAINT `manager_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`EmployeeID`);

--
-- Constraints for table `onlineloan`
--
ALTER TABLE `onlineloan`
  ADD CONSTRAINT `onlineloan_ibfk_1` FOREIGN KEY (`LoanID`) REFERENCES `loan` (`LoanID`);

--
-- Constraints for table `onlinetransaction`
--
ALTER TABLE `onlinetransaction`
  ADD CONSTRAINT `onlinetransaction_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transactions` (`TransactionID`);



--
-- Constraints for table `savingaccount`
--
ALTER TABLE `savingaccount`
  ADD CONSTRAINT `savingaccount_ibfk_1` FOREIGN KEY (`AccountNo`) REFERENCES `account` (`AccountNo`),
  ADD CONSTRAINT `savingaccount_ibfk_2` FOREIGN KEY (`PlanID`) REFERENCES `savingplan` (`PlanID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
