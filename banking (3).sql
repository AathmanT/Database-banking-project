-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2018 at 12:49 AM
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
-- Database: `banking test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcedureDepositLoan` (IN `SP_loanAmount` FLOAT(30,2), IN `SP_AccountNo` INT)  BEGIN

    DECLARE errno INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    GET CURRENT DIAGNOSTICS CONDITION 1 errno = MYSQL_ERRNO;
    SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'You cant do this transaction';
    ROLLBACK;
    END;

    START TRANSACTION;

     update account set Balance=Balance+SP_loanAmount where AccountNo=SP_AccountNo;
     insert into transactions (Amount,Date_Time,Type) values (SP_loanAmount,NOW(),'LoanDeposit');

    COMMIT WORK;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `checkFDEnough` (`fdAmount` FLOAT, `loanAmount` FLOAT) RETURNS INT(11) begin
             declare result int;
            if (loanAmount<=(fdAmount*0.6) and loanAmount<=500000) then
                set result=1;
            else set result=0;
            end if;
             return result;
        end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `checkPaidOnTime` (`PaidDate` DATE, `DueDate` DATE) RETURNS INT(11) begin
         declare result int;
        if (PaidDate<DueDate) then
            set result=1;
        else set result=0;
        end if;
         return result;
    end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `AccountNo` int(11) NOT NULL,
  `Balance` double DEFAULT '0',
  `BranchID` int(11) NOT NULL,
  `AccountType` enum('SavingAccount','CurrentAccount') NOT NULL,
  `PlanID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`AccountNo`, `Balance`, `BranchID`, `AccountType`, `PlanID`) VALUES
(1, 71000, 2, 'SavingAccount', 3),
(2, 0, 1, 'SavingAccount', 1);

--
-- Triggers `account`
--
DELIMITER $$
CREATE TRIGGER `checkBalance` BEFORE UPDATE ON `account` FOR EACH ROW BEGIN
if (NEW.Balance < 0 ) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'No Balance';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `account_balance`
-- (See below for the actual view)
--
CREATE TABLE `account_balance` (
`AccountNo` int(11)
,`CustomerName` varchar(30)
,`NIC` varchar(30)
,`Balance` double
);

-- --------------------------------------------------------

--
-- Table structure for table `atm`
--

CREATE TABLE `atm` (
  `atmID` int(11) NOT NULL,
  `BranchID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `atmtransaction`
--

CREATE TABLE `atmtransaction` (
  `TransactionID` int(11) NOT NULL,
  `AccountNo` varchar(30) DEFAULT NULL,
  `atmID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `atmtransaction`
--
DELIMITER $$
CREATE TRIGGER `checkAccountNo` BEFORE INSERT ON `atmtransaction` FOR EACH ROW BEGIN
            if ((SELECT COUNT(account.AccountNo) FROM account
            WHERE account.AccountNo =NEW.AccountNo) = 0  ) THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'wrong account number';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `BranchID` int(11) NOT NULL,
  `BranchType` enum('Head Office','Area Branch') DEFAULT NULL,
  `BranchName` varchar(30) NOT NULL,
  `BranchCity` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`BranchID`, `BranchType`, `BranchName`, `BranchCity`) VALUES
(1, 'Head Office', 'Jaffna', 'Jaffna'),
(2, 'Area Branch', 'Nallur', 'Jaffna'),
(3, 'Head Office', 'Mankulam', 'Vavuniya'),
(4, 'Area Branch', 'Kaithadi', 'Jaffna'),
(5, '', 'Kobai', 'Trinco'),
(6, 'Area Branch', 'Kokuvil', 'Baticola');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(30) NOT NULL,
  `CustomerAddress` varchar(30) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `NIC` varchar(30) DEFAULT NULL,
  `CustomerEmail` varchar(30) DEFAULT NULL,
  `CustomerPhoneNo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerID`, `CustomerName`, `CustomerAddress`, `DateOfBirth`, `NIC`, `CustomerEmail`, `CustomerPhoneNo`) VALUES
(1, 'fasfasf', 'asfsaf', '2018-11-07', '34344', 'sfafasf@gmail.com', 1234567890),
(2, 'fasfasf', 'asfsaf', '2018-11-28', '34344', 'sfafasf@gmail.com', 1234567890);

-- --------------------------------------------------------

--
-- Table structure for table `customer_account`
--

CREATE TABLE `customer_account` (
  `CustomerID` int(11) NOT NULL,
  `AccountNo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmployeeID` varchar(30) NOT NULL,
  `BranchID` int(11) DEFAULT NULL,
  `EmpName` varchar(30) DEFAULT NULL,
  `EmpAddress` varchar(30) DEFAULT NULL,
  `EmpEmail` varchar(30) DEFAULT NULL,
  `EmpPhoneNo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmployeeID`, `BranchID`, `EmpName`, `EmpAddress`, `EmpEmail`, `EmpPhoneNo`) VALUES
('1', 1, 'Stark', 'Malibu', 'Stark', 1221212),
('2', 2, 'Tony', 'Malibu', 'tony', 1221212);

-- --------------------------------------------------------

--
-- Table structure for table `fdplan`
--

CREATE TABLE `fdplan` (
  `FDPlanID` int(11) NOT NULL,
  `InterestRate` float(2,2) NOT NULL,
  `Period` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fdplan`
--

INSERT INTO `fdplan` (`FDPlanID`, `InterestRate`, `Period`) VALUES
(1, 0.12, 24);

-- --------------------------------------------------------

--
-- Table structure for table `fixeddeposit`
--

CREATE TABLE `fixeddeposit` (
  `FixedID` int(11) NOT NULL,
  `SavingNo` int(11) NOT NULL,
  `FDAmount` float(10,2) NOT NULL,
  `OpeningDate` date NOT NULL,
  `FDPlanID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fixeddeposit`
--

INSERT INTO `fixeddeposit` (`FixedID`, `SavingNo`, `FDAmount`, `OpeningDate`, `FDPlanID`) VALUES
(2, 1, 833334.00, '2018-11-28', 1);

--
-- Triggers `fixeddeposit`
--
DELIMITER $$
CREATE TRIGGER `checkAccountNoFD` BEFORE INSERT ON `fixeddeposit` FOR EACH ROW BEGIN
if ( (SELECT COUNT(account.AccountNo) FROM account
WHERE account.AccountNo =NEW.SavingNo) =0) THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'saving account no not found ';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loan`
--

CREATE TABLE `loan` (
  `LoanID` int(11) NOT NULL,
  `AccountNo` int(11) NOT NULL,
  `LoanType` enum('Personal Loan','Business Loan') DEFAULT NULL,
  `LoanAmount` float(30,2) DEFAULT NULL,
  `InterestRate` float(10,2) DEFAULT NULL,
  `MonthlyAmount` float(10,2) DEFAULT '0.00',
  `InstallmentRemaining` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan`
--

INSERT INTO `loan` (`LoanID`, `AccountNo`, `LoanType`, `LoanAmount`, `InterestRate`, `MonthlyAmount`, `InstallmentRemaining`) VALUES
(1, 1, 'Personal Loan', 10000.00, 0.12, 1477.78, 35),
(2, 1, '', 120000.00, 0.12, 0.00, 24),
(22, 1, 'Personal Loan', 11000.00, 0.12, 1778.33, 24);

--
-- Triggers `loan`
--
DELIMITER $$
CREATE TRIGGER `checkFDExists` BEFORE INSERT ON `loan` FOR EACH ROW BEGIN
             if(select count(SavingNo) from fixeddeposit where SavingNo=new.AccountNo)<1 THEN
              SIGNAL SQLSTATE '45000'
              SET MESSAGE_TEXT = 'Fixed Deposit not found';

            elseif checkFDEnough((select FDAmount from fixeddeposit where SavingNo=new.AccountNo),new.LoanAmount)=0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Fixed Deposit not enough';
            else set new.MonthlyAmount=((new.LoanAmount+ new.LoanAmount*0.12*new.InstallmentRemaining)/(new.InstallmentRemaining));
             end if;
           END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `depositLoan` AFTER INSERT ON `loan` FOR EACH ROW BEGIN

               update account set Balance=Balance+new.LoanAmount where AccountNo=new.AccountNo;
               insert into transactions (Amount,Date_Time,Type) values (new.LoanAmount,NOW(),'LoanDeposit');

         END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loanapplications`
--

CREATE TABLE `loanapplications` (
  `ApplicationID` int(11) NOT NULL,
  `LoanType` enum('Personal Loan','Business Loan') DEFAULT NULL,
  `AccountNo` int(11) DEFAULT NULL,
  `EmployeeID` varchar(30) DEFAULT NULL,
  `RepayYears` int(4) DEFAULT NULL,
  `Amount` float(30,2) DEFAULT NULL,
  `Approved` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Table structure for table `loansettlement`
--

CREATE TABLE `loansettlement` (
  `SettlementID` int(11) NOT NULL,
  `LoanID` int(11) NOT NULL,
  `DateTime` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `PaidOnTime` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loansettlement`
--

INSERT INTO `loansettlement` (`SettlementID`, `LoanID`, `DateTime`, `DueDate`, `PaidOnTime`) VALUES
(6, 1, '2018-11-28', '2018-11-29', 1),
(7, 1, '2018-11-30', '2018-11-29', 0),
(8, 1, '2018-11-28', '2018-11-29', 1),
(9, 1, '2018-11-27', '2018-11-29', 1),
(10, 1, '2018-12-02', '2018-11-29', 0),
(11, 1, '2018-11-28', '2018-11-29', 1);

--
-- Triggers `loansettlement`
--
DELIMITER $$
CREATE TRIGGER `checkPaidOnTime` BEFORE INSERT ON `loansettlement` FOR EACH ROW BEGIN
            set new.PaidOntime=checkPaidOnTime(new.DateTime,new.DueDate);

          END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reduceInstallment` AFTER INSERT ON `loansettlement` FOR EACH ROW BEGIN
                update loan set InstallmentRemaining=InstallmentRemaining-1 where LoanID=new.LoanID;

              END
$$
DELIMITER ;

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
  `LoanID` int(11) NOT NULL,
  `FixedID` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `onlinetransaction`
--

CREATE TABLE `onlinetransaction` (
  `TransactionID` int(11) NOT NULL,
  `SenderAccNo` varchar(30) DEFAULT NULL,
  `RecieverAccNo` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `onlinetransaction`
--
DELIMITER $$
CREATE TRIGGER `checkAccountNos` BEFORE INSERT ON `onlinetransaction` FOR EACH ROW BEGIN
if ((SELECT COUNT(account.AccountNo) FROM account
      WHERE account.AccountNo =NEW.SenderAccNo) = 0 or (SELECT COUNT(account.AccountNo)
  FROM account
         WHERE account.AccountNo =NEW.RecieverAccNo) = 0 ) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'wrong account numbers';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `plan`
--

CREATE TABLE `plan` (
  `PlanID` int(11) NOT NULL,
  `Category` varchar(30) DEFAULT NULL,
  `InterestRate` double DEFAULT NULL,
  `MinimumAmount` int(30) DEFAULT NULL,
  `NoOfWithdrawals` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plan`
--

INSERT INTO `plan` (`PlanID`, `Category`, `InterestRate`, `MinimumAmount`, `NoOfWithdrawals`) VALUES
(1, 'Children', 12, 0, 0),
(2, 'Teen', 11, 500, 10),
(3, 'Adult(18+)', 10, 1000, 15),
(4, 'Senior(60+)', 13, 1000, 12),
(5, 'NoInterest', 0, 5000, 20);

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
  `TransactionID` int(11) NOT NULL,
  `Amount` float(10,2) NOT NULL,
  `Date_Time` datetime NOT NULL,
  `Type` enum('Online','ATM') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`TransactionID`, `Amount`, `Date_Time`, `Type`) VALUES
(1, 10000.00, '2018-11-29 04:24:15', ''),
(2, 11000.00, '2018-11-29 04:49:09', '');

-- --------------------------------------------------------

--
-- Structure for view `account_balance`
--
DROP TABLE IF EXISTS `account_balance`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `account_balance`  AS  select `customer_account`.`AccountNo` AS `AccountNo`,`customer`.`CustomerName` AS `CustomerName`,`customer`.`NIC` AS `NIC`,`account`.`Balance` AS `Balance` from ((`customer` join `customer_account` on((`customer`.`CustomerID` = `customer_account`.`CustomerID`))) join `account` on((`customer_account`.`AccountNo` = `account`.`AccountNo`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`AccountNo`),
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
ALTER TABLE `branch`
  ADD PRIMARY KEY (`BranchID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerID`);

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
-- Indexes for table `loan`
--
ALTER TABLE `loan`
  ADD PRIMARY KEY (`LoanID`),
  ADD KEY `AccountNo` (`AccountNo`);

--
-- Indexes for table `loanapplications`
--
ALTER TABLE `loanapplications`
  ADD PRIMARY KEY (`ApplicationID`),
  ADD KEY `AccountNo` (`AccountNo`),
  ADD KEY `EmployeeID` (`EmployeeID`);

--
-- Indexes for table `loansettlement`
--
ALTER TABLE `loansettlement`
  ADD PRIMARY KEY (`SettlementID`),
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
-- Indexes for table `plan`
--
ALTER TABLE `plan`
  ADD PRIMARY KEY (`PlanID`);

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
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `AccountNo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `BranchID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `fdplan`
--
ALTER TABLE `fdplan`
  MODIFY `FDPlanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fixeddeposit`
--
ALTER TABLE `fixeddeposit`
  MODIFY `FixedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `loan`
--
ALTER TABLE `loan`
  MODIFY `LoanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `loanapplications`
--
ALTER TABLE `loanapplications`
  MODIFY `ApplicationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `loansettlement`
--
ALTER TABLE `loansettlement`
  MODIFY `SettlementID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `plan`
--
ALTER TABLE `plan`
  MODIFY `PlanID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `TransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`PlanID`) REFERENCES `plan` (`PlanID`),
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
  ADD CONSTRAINT `fixeddeposit_ibfk_1` FOREIGN KEY (`SavingNo`) REFERENCES `account` (`AccountNo`),
  ADD CONSTRAINT `fixeddeposit_ibfk_2` FOREIGN KEY (`FDPlanID`) REFERENCES `fdplan` (`FDPlanID`) ON DELETE CASCADE ON UPDATE CASCADE;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
