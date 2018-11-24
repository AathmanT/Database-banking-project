<!DOCTYPE html>
<html>
<style>
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
    <label for="sender">Sender Account No</label>
    <input type="text" id="sender" name="sender" placeholder="Sender..">

    <label for="reciever">Reciever Account No</label>
    <input type="text" id="reciever" required name="reciever" placeholder="Reciever..">

	
    <label for="amount">Amount</label>
    <input type="number"  id="amount" name="amount" required placeholder="Your amount.." min="0">
	
	<label for="TransactionID">TransactionID</label>
    <input type="text" id="TransactionID" name="TransactionID" placeholder="TransactionID..">
  
    <input type="submit" value="Submit">
  </form>
</div>


<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)){
	
$sender=$_POST['sender'];
$reciever=$_POST['reciever'];
$amount=$_POST['amount'];
$TransactionID=$_POST['TransactionID'];
	
	
//$db->multi_query("start transaction;insert into transactions (TransactionID,Amount,Date_Time,Type) values
// ('{$_POST['TransactionID']}','{$_POST['amount']}',NOW(),'Online');commit;");
 
 //$db->multi_query("start transaction;insert into onlinetransaction (TransactionID,SenderAccNo,RecieverAccNo) values
// ('{$_POST['TransactionID']}','{$_POST['sender']}','{$_POST['reciever']}');commit;");
 
 
// $db->multi_query("start transaction;update account set balance=balance+'{$_POST['amount']}' where AccountNo= '{$_POST['reciever']}';
// update account set balance=balance-'{$_POST['amount']}' where AccountNo= '{$_POST['sender']}';commit;");
 
 
 
 $result=$db->query("select balance from account where AccountNo='{$_POST['sender']}'");
 $currentBalance=$result->fetch_object()->balance;
 
 if(floatval($currentBalance)>floatval($_POST['amount'])){
	 
	 $db->query("insert into transactions (TransactionID,Amount,Date_Time,Type) values
 ('{$_POST['TransactionID']}','{$_POST['amount']}',NOW(),'Online')");
 
 $db->query("insert into onlinetransaction (TransactionID,SenderAccNo,RecieverAccNo) values
 ('{$_POST['TransactionID']}','{$_POST['sender']}','{$_POST['reciever']}')");
	 
	 $db->query("update account set balance=balance+'{$_POST['amount']}' where AccountNo= '{$_POST['reciever']}'");
	 
	 $db->query("update account set balance=balance-'{$_POST['amount']}' where AccountNo= '{$_POST['sender']}'");
 }
 
 else{
	 echo "You don't have enough balance";
 }
 
 
 
 
	
}


if($results=$db->query("SELECT * FROM transactions")){
	if($results->num_rows){
		while($row=$results->fetch_object()){
			$records[]=$row;
		}
		$results->free();
	}
} $i=0;


?>
    <table>
        <thead>
            <tr>
                <th>TransactionID</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody> 
		<?php
			foreach($records as $r){
				$i++;
		?>
			<tr>
				<td><?php echo $r->TransactionID;?></td>
				<td><?php echo $r->Amount;?></td>
			</tr>
		<?php
		}
		?>
        </tbody>
    </table>
	</body>
</html>