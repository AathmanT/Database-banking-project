<!DOCTYPE html>
<html>
<style>

    #Loan type{
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

<h3>Online Loan Application </h3>

<div>
    <form action="" method="post">
        <label for="AccountNo">AccountNo</label>
        <input type="text" id="AccountNo" name="AccountNo" placeholder="AccountNo..">


        <label for="LoanType">LoanType</label>
        <select id="LoanType" name="LoanType">
            <option value="BusinessLoan">BusinessLoan</option>
            <option value="PersonalLoan">PersonalLoan</option>
        </select>

        <label for="Amount">Amount</label>
        <input type="number" id="Amount" name="Amount" placeholder="Amount..">


        <label for="RepayMonths">RepayMonths</label>
        <input type="number"  id="RepayMonths" name="RepayMonths" required placeholder="RepayMonths.." min="0">



        <input type="submit" value="Submit">
    </form>
</div>

<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)) {



    //$db->query("insert into loan (AccountNo,LoanType,LoanAmount,InterestRate,InstallmentRemaining) values
    //('{$_POST['AccountNo']}','{$_POST['LoanType']}','{$_POST['Amount']}',0.12,'{$_POST['RepayMonths']}')");
    $stmt = $db->prepare("insert into loan (AccountNo,LoanType,LoanAmount,InterestRate,InstallmentRemaining) values
 (?,?,?,?,?)");
    $stmt->bind_param('isddi',$_POST['AccountNo'], $_POST['LoanType'],$_POST['Amount'],0.12,$_POST['RepayMonths']);
    $stmt->execute();

    //insert into loan (AccountNo,LoanType,LoanAmount,InterestRate,InstallmentRemaining) values
    //(1,'Business',10000,0.12,24)
}