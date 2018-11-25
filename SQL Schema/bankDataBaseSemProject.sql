CREATE DATABASE banking;
USE banking;

CREATE TABLE IF NOT EXISTS Account(
	AccountNo VARCHAR(30) not null,
	Balance FLOAT(30) default 0,
	BranchID VARCHAR(30) not null,
	AccountType ENUM("SavingAccount"," CurrentAccount") not null,
	PRIMARY KEY(AccountNo),
	FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
	);
	
INSERT INTO `account` (`AccountNo`, `Balance`, `BranchID`, `AccountType`) VALUES
('160001', 800, '10', 'SavingAccount'),
('160002', 600, '10', 'SavingAccount');

CREATE TABLE IF NOT EXISTS ATM(
	atmID VARCHAR(30) not null,
	BranchID VARCHAR(30) not null,
	PRIMARY KEY(atmID),
	FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
	);
	
CREATE TABLE IF NOT EXISTS ATMTransaction(
	TransactionID VARCHAR(30) not null,
	AccountNo VARCHAR(30) not null,
	atmID Varchar(30) not null,
	PRIMARY KEY(TransactionID),
	FOREIGN KEY(TransactionID) REFERENCES Transactions(TransactionID),
	FOREIGN KEY(atmID) REFERENCES ATM(atmID)
	);

CREATE TABLE IF NOT EXISTS Branch(
	BranchID VARCHAR(30) not null,
	BranchType ENUM("Head Office","Area Branch") not null,
	BranchName VARCHAR(30) not null,
	BranchCity VARCHAR(30) not null,
	PRIMARY KEY(BranchID)
	);
	
INSERT INTO `branch` (`BranchID`, `BranchType`, `BranchName`, `BranchCity`) VALUES
('10', 'Area Branch', 'Colombo', 'Moratuwa');

CREATE TABLE IF NOT EXISTS Customer(
	CustomerID VARCHAR(30) not null,
	CustomerName VARCHAR(30) not null,
	CustomerAddress VARCHAR(30) not null,
	CustomerEmail VARCHAR(30),
	CustomerPhoneNo int,
	PRIMARY KEY(CustomerID)
	);
	
CREATE TABLE IF NOT EXISTS Customer_Account(
	CustomerID VARCHAR(30) not null,
	AccountNo VARCHAR(30) not null,
	CONSTRAINT PK_Customer_Account PRIMARY KEY (CustomerID,AccountNo)
	);
		
CREATE TABLE IF NOT EXISTS Employee(
	EmployeeID VARCHAR(30) not null,
	BranchID VARCHAR(30) not null,
	EmpName VARCHAR(30) not null,
	EmpAddress VARCHAR(30) not null,
	EmpEmail VARCHAR(30) not null,
	EmpPhoneNo int not null,
	PRIMARY KEY(EmployeeID),
	FOREIGN KEY(BranchID) REFERENCES Branch(BranchID)
	);
	
INSERT INTO `employee` (`EmployeeID`, `BranchID`, `EmpName`, `EmpAddress`, `EmpEmail`, `EmpPhoneNo`) VALUES
('160001', '10', 'Tony', 'Malibu', 'tony', 1221212);

CREATE TABLE IF NOT EXISTS FDPlan(
	FDPlanID VARCHAR(30) not null,
	InterestRate FLOAT(30) not null,
	Period int not null,
	PRIMARY KEY(FDPlanID)
	);
	
CREATE TABLE IF NOT EXISTS FixedDeposit(
	FixedID VARCHAR(30) not null,
	SavingNo VARCHAR(30) not null,
	FDAmount VARCHAR(30) not null,
	InterestRate FLOAT(30) not null,
	OpeningDate Date not null,
	FDPlanID VARCHAR(30) not null,
	PRIMARY KEY(FixedID),
	FOREIGN KEY(SavingNo) REFERENCES SavingAccount(AccoutnNo),
	FOREIGN KEY(FDPlanID) REFERENCES FDPlan(FDPlanID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	);

CREATE TABLE IF NOT EXISTS LateLoanReport(
	ReportID varchar(30) not null,
	Date DATETIME not null,
	SettlementID varchar(30)not null,
	FOREIGN KEY(SettlementID) REFERENCES LoanSettlement(SettlementID)
	
);		

CREATE TABLE IF NOT EXISTS Loan(
	LoanID int AUTO_INCREMENT primary key,
	InstallmentID VARCHAR(30) not null,
	AccountNo varchar(30) not null,
	LoanType ENUM("Personal Loan","Business Loan") not null,
	LoanAmount FLOAT(30,2) not null,
	InterestRate FLOAT(10,2) not null,
	Manual_Online ENUM("Manual","Online"),
	FOREIGN KEY(AccountNo) REFERENCES Account(AccountNo),
	FOREIGN KEY(InstallmentID) REFERENCES LoanInstallment(InstallmentID)
	);

CREATE TABLE IF NOT EXISTS LoanApplications(
	ApplicationID int auto_increment,
	LoanType ENUM("Personal Loan","Business Loan") not null,
	AccountNo VARCHAR(30) not null,
	EmployeeID varchar(30) not null,
	RepayYears int(4) not null,
	Amount FLOAT(30,2) not null,
	Approved boolean not null,
	PRIMARY KEY(ApplicationID),
	FOREIGN KEY(AccountNo) REFERENCES Account(AccountNo),
	FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
	);
		

	
INSERT INTO `loanapplications` (`ApplicationID`, `LoanType`, `AccountNo`, `EmployeeID`, `RepayYears`, `Amount`, `Approved`) VALUES
(12, '', '160001', '160001', 3, 10000.00, 0);

CREATE TABLE IF NOT EXISTS LoanInstallment(
	InstallmentID varchar(30) not null,
	PaymentPeriod int(30) not null,
	MonthlyAmount FLOAT(30) not null,
	InstallmentRemaining FLOAT(30) not null,
	PRIMARY KEY(InstallmentID)
	);
	

INSERT INTO `loaninstallment` (`InstallmentID`, `PaymentPeriod`, `MonthlyAmount`, `InstallmentRemaining`) VALUES
('10001', 12, 1000, 10);

CREATE TABLE IF NOT EXISTS LoanSettlement(
	SettlementID varchar(30) not null,
	InstallmentID varchar(30) not null,
	DateTime DATE not null,
	PaidOnTime boolean not null,
	PRIMARY KEY(SettlementID),
	FOREIGN KEY(InstallmentID) REFERENCES LoanInstallment(InstallmentID)
	);


INSERT INTO `loansettlement` (`SettlementID`, `InstallmentID`, `DateTime`, `DueDate`, `PaidOnTime`) VALUES
('160001', '10001', '2018-11-08', '2018-11-10', 0),
('160002', '10001', '2018-11-08', '2018-11-10', 0),
('160003', '10001', '2018-11-08', '2018-11-10', 0),
('160004', '10001', '2018-11-08', '2018-11-10', 0),
('160005', '10001', '2018-11-08', '2018-11-10', 0),
('160008', '10001', '2018-11-08', '2018-11-10', 1),
('160009', '10001', '2018-11-08', '2018-11-10', 1),
('160010', '10001', '2018-11-08', '2018-11-10', 1);

CREATE TABLE IF NOT EXISTS Login(
	Type ENUM("Employee","Customer","Manager") not null,
	Username VARCHAR(30) not null, 
	Password VARCHAR(30) not null,
	BankID VARCHAR(30) not null,
	PRIMARY KEY(Username)
	);
	
CREATE TABLE IF NOT EXISTS Manager(
	EmployeeID VARCHAR(30) not null,
	PRIMARY KEY(EmployeeID),
	FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
	);
	
CREATE TABLE IF NOT EXISTS OnlineLoan(
	LoanID VARCHAR(30) not null,
	FixedID VARCHAR(30) not null,
	PRIMARY KEY(LoanID),
	FOREIGN KEY(LoanID) REFERENCES Loan(LoanID)
	);
	
CREATE TABLE IF NOT EXISTS OnlineTransaction(
	TransactionID VARCHAR(30) not null,
	SenderAccNo VARCHAR(30) not null,
	RecieverAccNo VARCHAR(30) not null,
	PRIMARY KEY(TransactionID),
	FOREIGN KEY(TransactionID) REFERENCES Transactions(TransactionID)
	);

	
INSERT INTO `onlinetransaction` (`TransactionID`, `SenderAccNo`, `RecieverAccNo`) VALUES
('2', '160001', '160002'),
('3', '160001', '160002'),
('4', '160001', '160002'),
('5', '160001', '160002'),
('6', '160001', '160002'),
('7', '160001', '160002'),
('8', '160001', '160002');

	
	DELIMITER $$
        CREATE TRIGGER balanceCheck 
        BEFORE INSERT 
        ON transactions
        FOR EACH ROW
        BEGIN
          if (NEW.amount < 0) THEN 
             SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot do the transaction, balance not enough';
          END IF;
        END $$
    DELIMITER ;
	
CREATE TABLE IF NOT EXISTS SavingAccount(
	NoOfWithdrawals int defalut 0,
	AccoutnNo VARCHAR(30) not null,
	PlanID VARCHAR(30) not null,
	PRIMARY KEY(AccountNo),
	FOREIGN KEY(AccountNo) REFERENCES Account(AccountNo),
	FOREIGN KEY(PlanID) REFERENCES SavingPlan(PlanID)
	);
	
	
CREATE TABLE IF NOT EXISTS SavingPlan(
	PlanID VARCHAR(30) not null,
	InterestRate FLOAT(30) not null,
	MinimumAmount int(30) not null,
	PRIMARY KEY(PlanID)
	);
	
CREATE TABLE IF NOT EXISTS 	TransactionReport(
	ReportID varchar(30) not null,
	Date DateTime not null,
	TotalWidrawal FLOAT(30) not null,
	TotalDeposit FLOAT(30) not null,
	CONSTRAINT PK_TransactionReport PRIMARY KEY (ReportID,Date)
	);
	
	
CREATE TABLE IF NOT EXISTS Transactions(
	TransactionID VARCHAR(30) not null,
	Amount FLOAT(30,2) not null,
	Date_Time DATETIME not null,
	Type ENUM("Online","ATM") not null,
	PRIMARY KEY(TransactionID)
	);
	
INSERT INTO `transactions` (`TransactionID`, `Amount`, `Date_Time`, `Type`) VALUES
('1', 50.00, '2018-11-08 01:37:25', 'Online'),
('2', 50.00, '2018-11-08 01:46:35', 'Online'),
('3', 50.00, '2018-11-08 01:53:39', 'Online'),
('4', 100.00, '2018-11-08 02:48:38', 'Online'),
('5', 1.00, '2018-11-08 10:47:20', 'Online'),
('6', 50.00, '2018-11-08 10:48:09', 'Online'),
('7', 100.00, '2018-11-08 10:49:30', 'Online'),
('8', 50.00, '2018-11-08 10:51:56', 'Online');
	

	
	

	

	

	

	
	
	
	

	

	


	


	


	


	
	
	
	
	
	