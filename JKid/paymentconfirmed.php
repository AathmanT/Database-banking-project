<?php
require_once 'header.php';
if(isset($_GET['order_ID'])&&isset($_GET['payment_ID'])){
	$conn = mysqli_connect("localhost", "root", "", "angaadi");
	$order_ID = $_GET['order_ID'];
	$payment_ID = $_GET['payment_ID'];
	$query0 = "Select * FROM payment where payment_ID='$payment_ID'&&Payment_method='pay by card';";
	$result0 = mysqli_num_rows(mysqli_query($conn, $query0));
	if($result0!=0){
		$query = "UPDATE payment SET Payment_status = 'paid' where payment_ID='$payment_ID';";
		$result = mysqli_query($conn, $query);
		if($result){echo "You Order has been paid Successfully. Your order wil be confirmed within few hours!";}
	}
	else{
		echo "You Order has been Recorded Successfully. Your order wil be Delivered!";
	}
}

?>
	<!-- Custom js -->
	<!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <script type="text/JavaScript" src="js/custom_checkout.js"></script>
<?php require_once 'footer.php';?>