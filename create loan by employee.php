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

<h3>Online Transaction </h3>

<div>
    <form action="" method="post">
        <label for="Account no">Account no</label>
        <input type="text" id="Account no" name="Account no" placeholder="Account no..">

        <label for="Loan type">Loan type</label>
        <select id="Loan type" name="Loan type">
            <option value="volvo">Business</option>
            <option value="saab">Personal</option>
        </select>



        <label for="RepayYears">RepayYears</label>
        <input type="number"  id="RepayYears" name="RepayYears" required placeholder="RepayYears.." min="0">

        <label for="Amount">Amount</label>
        <input type="number" id="Amount" name="Amount" placeholder="Amount..">

        <input type="submit" value="Submit">
    </form>
</div>

<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)) {

    $sender = $_POST['sender'];
    $reciever = $_POST['reciever'];
    $amount = $_POST['amount'];
    $TransactionID = $_POST['TransactionID'];

    $db->query("insert into transactions (TransactionID,Amount,Date_Time,Type) values
 ('{$_POST['TransactionID']}','{$_POST['amount']}',NOW(),'Online')");
}