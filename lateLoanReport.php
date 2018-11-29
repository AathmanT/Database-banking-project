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
    <label for="StartDate">StartDate</label>
    <input type="text" id="StartDate" name="StartDate" placeholder="StartDate..">

    <label for="EndDate">EndDate</label>
    <input type="text" id="EndDate" required name="EndDate" placeholder="EndDate..">
  
    <input type="submit" value="GenerateReport">
  </form>
</div>


<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)){


//$db->multi_query("start transaction;insert into transactions (TransactionID,Amount,Date_Time,Type) values
// ('{$_POST['TransactionID']}','{$_POST['amount']}',NOW(),'Online');commit;");
 
 //$db->multi_query("start transaction;insert into onlinetransaction (TransactionID,SenderAccNo,RecieverAccNo) values
// ('{$_POST['TransactionID']}','{$_POST['sender']}','{$_POST['reciever']}');commit;");
 
 
// $db->multi_query("start transaction;update account set balance=balance+'{$_POST['amount']}' where AccountNo= '{$_POST['reciever']}';
// update account set balance=balance-'{$_POST['amount']}' where AccountNo= '{$_POST['sender']}';commit;");
 


//if($results=$db->query("SELECT AccountNo,DateTime,DueDate from  loansettlement left join loan using(LoanID) left join account using(AccountNo) where BranchID=2 and PaidOnTime=0 and DueDate between '2018-10-01' and '2018-12-01'")){
   // if($results=$db->query("SELECT AccountNo,DateTime,DueDate from  loansettlement left join loan using(LoanID) left join account using(AccountNo) where BranchID=2 and PaidOnTime=0 and DueDate between '{$_POST['StartDate']}' and '{$_POST['EndDate']}'")){
    if($results=$db->query("SELECT AccountNo,DateTime,DueDate from  lateloanreport where BranchID=2 and PaidOnTime=0 and DueDate between '{$_POST['StartDate']}' and '{$_POST['EndDate']}'")){
    if($results->num_rows){
        var_dump($results);
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
                <th>AccountNo</th>
                <th>PaidTime</th>
                <th>DueDate</th>
            </tr>
        </thead>
        <tbody> 
		<?php
			foreach($records as $r){
				$i++;
		?>
			<tr>
				<td><?php echo $r->AccountNo;?></td>
				<td><?php echo $r->DateTime;?></td>
                <td><?php echo $r->DueDate;?></td>
			</tr>
		<?php
		}
		?>
        </tbody>
    </table>
<?php } ?>
	</body>
</html>
