<?php

$db=new mysqli('localhost','root','','banking');

if(!empty($_POST)){
	
$SettlementID=$_POST['SettlementID'];
$InstallmentID=$_POST['InstallmentID'];
	
if(time()-strtotime('2018-11-10 11:59:00.0')<0){
	
	$db->query("insert into loansettlement (SettlementID,InstallmentID,DateTime,DueDate,PaidOnTime) values
 ('{$_POST['SettlementID']}','{$_POST['InstallmentID']}',NOW(),'2018-11-10 11:59:00.0',1)");
}
else{
	$db->query("insert into loansettlement (SettlementID,InstallmentID,DateTime,DueDate,PaidOnTime) values
 ('{$_POST['SettlementID']}','{$_POST['InstallmentID']}',NOW(),'2018-11-10 11:59:00.0',0)");
}

 $result=$db->query("select InstallmentRemaining from loaninstallment where InstallmentID='{$_POST['InstallmentID']}'");
 $currentinstallment=$result->fetch_object()->InstallmentRemaining;
	
if($currentinstallment>=1){
	$db->query("update loaninstallment set InstallmentRemaining=InstallmentRemaining-1 where InstallmentID='{$_POST['InstallmentID']}'");
}	
 
 
	
}
 if($db->affected_rows){
	echo "Success!!!";
	} else{
		echo "Failiure???";
	} 
?>