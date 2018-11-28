<!DOCTYPE html>
<html>
<style>
    input[type=text], input[type=email],input[type=tel],input[type=date],select {
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

<h3>Fixed Deposit  </h3>

<div>
    <form action="" method="post">


        <label for="savingaccountno">SavingAccountNo</label>
        <input type="text" id="savingaccountno" required name="savingaccountno" placeholder="savingaccountno..">

        <label for="amount">Amount</label>
        <input type="text" id="amount" required name="amount" placeholder="amount..">

        <label for="openingdate">Opening Date</label><br>
        <input type="date" id="openingdate" required name="openingdate" placeholder="openingdate..">

        <label for="period">Period</label>
        <select type="text" id="period" required name="period">
            <option>6 Months </option>
            <option>1 Year</option>
            <option>3 Year</option>
        </select>




        <input type="submit" value="Submit">

    </form>
</div>

<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)) {

    $AccountType = $_POST['accounttype'];
    $CustomerName = $_POST['customername'];
    $CustomerAddress = $_POST['customeraddress'];
    $DateOfBirth = $_POST['dateofbirth'];
    $NIC=$_POST['NIC'];
    $CustomerEmail=$_POST['customeremail'];
    $CustomerPhoneNo=$_POST['customerphoneno'];
    $BranchName=$_POST['branchname'];

    $db->query("insert into customer (CustomerName,CustomerAddress,DateOfBirth,NIC,CustomerEmail,CustomerPhoneNo) values
 ('{$_POST['customername']}','{$_POST['customeraddress']}','{$_POST['dateofbirth']}','{$_POST['NIC']}','{$_POST['customeremail']}',
 '{$_POST['customerphoneno']}')");

    $db->query("insert into account (AccountNo,BranchID,AccountType) values
 ('160002',select branchID from branch where branchName='{$_POST['branchname']}','{$_POST['accounttype']}')");

    //$db->query("insert into ")

    //  var_dump($db->query("select last_insert_id() from account")->fetch_object());

}
//insert into account (AccountNo,BranchID,AccountType) values
//  ('160001',(select branchID from branch where branchName='Jaffna'),'SavingAccount')
?>
