<?php
require_once 'header.php';
if(isset($_POST['phone'])){
	$firstname = $_POST['firstname'];
	$lastname = $_POST['lastname'];
	$street = $_POST['street'];
	$city = $_POST['city'];
	$state = $_POST['state'];
	$zip = $_POST['zip'];
	$deliverymethod = $_POST['deliverymethod'];
	$phone = $_POST['phone'];
	$conn = mysqli_connect("localhost", "root", "", "angaadi");
	$payment_status = 'Not Paid';
	$payment_method = $_POST['payment_method'];
	$date = date('Y-m-d H:i:s');
	$order_ID = mysqli_fetch_assoc(mysqli_query($conn,"Select MAX(order_ID) AS 'ord' from orders;"))['ord'];
	if($deliverymethod!='Home Delivery'){
		$query ="UPDATE orders SET Delivery_Method='$deliverymethod' WHERE order_ID='$order_ID';";
		$result = mysqli_query($conn, $query);
		if(!$result){die('Something went wrong!');}
	}
	$query = "INSERT INTO shipping_address (FirstName,LastName,	order_ID,City,State,Zip_Code,Address_Line,PhoneNumber)"
									."VALUES('$firstname','$lastname','$order_ID', '$city','$state', '$zip','$street','$phone');";
	$result = mysqli_query($conn, $query);
	$query1 = "INSERT INTO payment (order_Id,Payment_method,Payment_Date,Payment_status)"
									."VALUES('$order_ID','$payment_method','$date', '$payment_status');";
	$result1	= mysqli_query($conn, $query1);
	$payment_ID= mysqli_fetch_assoc(mysqli_query($conn, "SELECT LAST_INSERT_ID() AS 'pid' FROM payment;"))['pid'];
	if(!$result){
		if(mysqli_query($conn, "Select * from shipping_address where order_ID='$$order_ID'")){
			$payment_ID= mysqli_fetch_assoc(mysqli_query($conn, "SELECT Payment_ID AS 'pid' FROM payment WHERE order_ID='$order_ID';"))['pid'];
			echo "Order Already Confirmed!</br><a href='paymentconfirmed.php?order_ID=$order_ID&payment_ID=$payment_ID'>To pay the order >>></a>";}
		else{
			die('Something went wrong!');
		}
	}
	else{
		echo'<meta http-equiv="refresh" content="0;url=paymentconfirmed.php?order_ID=$order_ID&payment_ID=$payment_ID">';
	}
	
}

?>
	<div class="cart_section">
		<div class="container">
				<div class="row">
					<div class="col-lg-10 offset-lg-1">
						<div class="cart_container">
							<div class="cart_title">Check Out</div>
								<form method="post" action="checkout.php">
									<div id='container1'>
										<div class='left1'><input type="radio" name="deliverymethod" value="Store Pickup" checked="checked"/>Pick Up</div></br>
										<div class='left1'><input type="radio" name="deliverymethod" value="Home Delivery" id="doordelivery"/> Door Delivery</div></br>
										<div id='addresscontainer' hidden='True'>
											<div class="col-md-6 mb-3">
												<input type="text" class="form-control" id="first_name" name="firstname"value="" placeholder="First Name">
											</div>
											<div class="col-md-6 mb-3">
												<input type="text" class="form-control" id="last_name" name="lastname"value="" placeholder="Last Name">
											</div>
											<div class="col-12 mb-3">
												<input type="text" class="form-control mb-3" id="street_address" name="street" placeholder="Address" value="">
											</div>
											<div class="col-12 mb-3">
												<input type="text" class="form-control" id="city" name="city"placeholder="Town" value="">
											</div>
											<div class="col-12 mb-3">
												<input type="text" class="form-control" id="state" name="state"placeholder="State" value="">
											</div>
											<div class="col-md-6 mb-3">
												<input type="text" class="form-control" id="zipCode"name="zip" placeholder="Zip Code" value="">
											</div>
											<div class="col-md-6 mb-3">
												<input type="number" class="form-control" id="phone_number" name="phone" min="0" placeholder="Phone No" value="">
											</div>
										</div>
										<div class='left1'><input type="radio" name="payment_method" value="pay by card" checked="checked"/>Pay by Card</div></br>
										<div class='left1'><input type="radio" name="payment_method" value="pay on delivery" /> Pay on Delivery</div></br>
										
									</div>
									<div class="cart_buttons">
										<input type="submit" name="submit" class="button cart_button_checkout" value="Confirm and Pay">
									</div>
								</form>
						</div>
					</div>
				</div>
		</div>
	</div>
	<!-- Custom js -->
	<!-- ##### jQuery (Necessary for All JavaScript Plugins) ##### -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <script type="text/JavaScript" src="js/custom_checkout.js"></script>
<?php require_once 'footer.php';?>