<?php
require_once 'header.php';
$query="Select * from orders where customer_ID = '$customer_ID'";
$result = mysqli_query($conn, $query);
$query0="Select DISTINCT order_ID, Payment_ID from orders NATURAL JOIN payment where customer_ID = '$customer_ID' AND Payment_status='paid';";
$result0 = mysqli_query($conn, $query0);
$paid_order_IDs = array();
while($row=mysqli_fetch_row($result0)){
	$paid_order_IDs[] = $row[0];
}
if($result){
	$record = mysqli_fetch_assoc($result);
	echo '<table class="universal_table"><tr class="universal_table">';
		foreach($record as $key => $data){
			echo "<th class='universal_table'>$key</th>";
		}
		echo '<th class="universal_table">Payment</th><th class="universal_table">Details</th></tr>';
	while($record){
		$order_ID = $record['order_ID'];
		echo '<tr class="universal_table">';
		foreach($record as $key => $data){
			echo "<td class='universal_table' width='auto'>$data</td>";
		}
		if(in_array($order_ID,$paid_order_IDs)){
			echo "<td class='universal_table' width='auto'>Paid</td>";
		}
		else{
			$payment_ID = mysqli_fetch_row(mysqli_query($conn, "Select Payment_ID from orders NATURAL JOIN payment where customer_ID = '$customer_ID' AND order_ID='$order_ID' Limit 1;"))[0];
			if($payment_ID){
				echo "<td class='universal_table' width='auto'><a href='paymentconfirmed.php?order_ID=$order_ID&payment_ID=$payment_ID'>Pay Now</a></td>";
			}
			else{
				echo "<td class='universal_table' width='auto'>Cancelled</td>";
			}
		}
		echo "<td class='universal_table' width='auto'><a href='order_details.php?order_ID=$order_ID'>Details</a></td>";
		echo '</tr>';
		//echo '<td width="auto"><a class="_button" href="profile?client_id='.$customer[1].'">'.$customer[0].'</a></td>';
		$record = mysqli_fetch_assoc($result);
	}
	echo '</table>';
}
require_once 'footer.php';
?>