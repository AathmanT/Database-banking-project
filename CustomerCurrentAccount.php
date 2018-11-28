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

<h3>Customer CurrentAccount Registration </h3>

<div>
    <form action="" method="post">
        <label for="accounttype">AccountType</label>
        <select type="text" id="accounttype" required name="accounttype">
            <option>CurrentAccount</option>
        </select>

        <label for="category">Category</label>
        <select type="text" id="category" required name="category">
            <option>NoInterest</option>
        </select>

        <label for="customername">CustomerName</label>
        <input type="text" id="customername" required name="customername" placeholder="CustomerName..">

        <label for="customeraddress">CustomerAddress</label>
        <input type="text" id="customeraddress" required name="customeraddress" placeholder="CustomerAddress..">

        <label for="dateofbirth">DateOfBirth</label><br>
        <input type="date" id="dateofbirth" required name="dateofbirth" placeholder="DateOfBirth..">

        <label for="NIC">NIC</label>
        <input type="text" id="NIC" name="NIC" placeholder="NIC..">

        <label for="customeremail">CustomerEmail</label>
        <input type="email"  id="customeremail" name="customeremail" placeholder="CustomerEmail..">

        <label for="customerphoneno">CustomerPhoneNo</label>
        <input type="tel" pattern="[0-9]{10}" id="customerphoneno" required name="customerphoneno" placeholder="CustomerPhoneNo..">

        <label for="branchname">BranchName</label>
        <select type="text" id="branchname" required name="branchname">
            <option>BranchName..</option>
            <option>Jaffna</option>
            <option>Kaithadi</option>
            <option>Nallur</option>
            <option>Kobai</option>
            <option>Kokuvil</option>
        </select>


        <input type="submit" value="Submit">

    </form>
</div>

<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)) {

    $AccountType = $_POST['accounttype'];
    $Category=$_POST['category'];
    $CustomerName = $_POST['customername'];
    $CustomerAddress = $_POST['customeraddress'];
    $DateOfBirth = $_POST['dateofbirth'];
    $NIC=$_POST['NIC'];
    $CustomerEmail=$_POST['customeremail'];
    $CustomerPhoneNo=$_POST['customerphoneno'];
    $BranchName=$_POST['branchname'];


    //insert into customer table
    $stmt = $db->prepare("insert into customer (CustomerName,CustomerAddress,DateOfBirth,NIC,CustomerEmail,CustomerPhoneNo) 
    values (?,?,?,?,?,?)");
    $stmt->bind_param('sssssi',$_POST['customername'], $_POST['customeraddress'],$_POST['dateofbirth'],$_POST['NIC'],$_POST['customeremail'],$_POST['customerphoneno']);
    $stmt->execute();

    //insert into account table
    $bid=$db->prepare("select branchID from branch where branchName=?");
    $bid->bind_param('s',$_POST['branchname']);
    $bid->execute();
    $result = $bid->get_result();
    $var1 = $result->fetch_object()->branchID;

    $pid=$db->prepare("select planID from savingplan where category=?");
    $pid->bind_param('s',$_POST['category']);
    $pid->execute();
    $result1 = $pid->get_result();
    $var2 = $result1->fetch_object()->planID;

    $stm = $db->prepare("insert into account (BranchID,AccountType,PlanID) values
 (?,?,?)");
    $stm->bind_param('isi',$var1,$_POST['accounttype'],$var2);
    $stm->execute();

    //insert into customer_account table
    $ca=$db->prepare("insert into customer_account (CustomerID,AccountNo) values (?,?)");
    $v1=$db->query("select max(CustomerID) as cid from customer");
    $r1 = $v1->fetch_object()->cid;

    $v2=$db->query("select max(AccountNo) as aid from account");
    $r2=$v2->fetch_object()->aid;

    $ca->bind_param('ii',$r1,$r2);
    $ca->execute();
    //var_dump($r1);
    //var_dump($r2);
    //var_dump($var1);
    //var_dump($var2);

    /*
    $db->query("insert into customer (CustomerName,CustomerAddress,DateOfBirth,NIC,CustomerEmail,CustomerPhoneNo) values
 ('{$_POST['customername']}','{$_POST['customeraddress']}','{$_POST['dateofbirth']}','{$_POST['NIC']}','{$_POST['customeremail']}',
 '{$_POST['customerphoneno']}')");


    $db->query("insert into account (BranchID,AccountType,PlanID) values
 ((select branchID from branch where branchName='{$_POST['branchname']}'),'{$_POST['accounttype']}',(select PlanID from savingplan where category='{$_POST['category']}'))");

   $db->query("insert into customer_account (CustomerID,AccountNo) values ((select max(CustomerID) from customer),(select max(AccountNo) from account))");
    $db->query("insert into customer_account (CustomerID,AccountNo) values (last_insert_id(),last_insert_id())");
    */
}
?>
