<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)) {

    $sender = $_POST['AccountNo'];
    $reciever = $_POST['LoanType'];
    $amount = $_POST['RepayYears'];
    $TransactionID = $_POST['Amount'];

    $db->query("insert into loanapplications (LoanType,AccountNo,EmployeeID,RepayYears,Amount) values
 ('{$_POST['LoanType']}','{$_POST['AccountNo']}','160001','{$_POST['RepayYears']}','{$_POST['Amount']}')");
}

?>

<!DOCTYPE html>
<html>
<style>

    #LoanType{
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    input[type=text], select {
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    input[type=number],select {
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }



    input[type=submit] {
        width: 100%;
        background-color: #4CAF50;
        color: white;
        padding: 14px 20px;
        margin: 8px 0;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    input[type=submit]:hover {
        background-color: #45a049;
    }

    div {
        border-radius: 5px;
        background-color: #f2f2f2;
        padding: 20px;
        width:50%
    }
</style>
<body>

<h3>Manual Loan </h3>

<div>
    <form action="" method="post">
        <label for="AccountNo">Account no</label>
        <input type="text" id="AccountNo" name="AccountNo" placeholder="Account no..">

        <label for="LoanType">Loan type</label>
        <select id="LoanType" name="LoanType">
            <option value="Business">Business</option>
            <option value="Personal">Personal</option>
        </select>


        <label for="RepayYears">RepayYears</label>
        <input type="number"  id="RepayYears" name="RepayYears" required placeholder="RepayYears.." min="0">

        <label for="Amount">Amount</label>
        <input type="number" id="Amount" name="Amount" placeholder="Amount..">

        <input type="submit" value="Submit">
    </form>
</div>

