<?php
	require_once 'header.php';
	if(isset($_GET['order_ID'])){$order_ID = $_GET['order_ID'];}else{echo 'Select order first!';}
	$query = "SELECT * FROM Product_Variant NATURAL JOIN Product NATURAL JOIN orders NATURAL JOIN order_detail NATURAL LEFT OUTER JOIN payment NATURAL LEFT OUTER JOIN shipping_address WHERE order_ID='$order_ID' LIMIT 1";
	$items = mysqli_query($conn, $query);//||exit();\
?>
	<div class="cart_section"style="width:100%;">
		<div class="row">
			<div class="col-lg-10 offset-lg-1">
				<div class="cart_container">
					<div class="cart_title">
					</div>
					<div class="cart_items">
						<ul class="cart_list">
						<?php
						if($items){
							while($item = mysqli_fetch_assoc($items)){
								$image = base64_encode($item['Image']);
								$name = $item['product_name'];
								$unit_Price = $item['unit_Price'];
								$Quantity = $item['Quantity'];
								$payment_status =$item['Payment_status']!=""? $item['Payment_status']:"Not Paid";
								$Total = $unit_Price*$Quantity;
								if($item['FirstName']!=""){
									$shipment = "";
									$shipment.=$item['FirstName'].',</br>';
									$shipment.=$item['LastName'].',</br>';
									$shipment.=$item['Address_Line'].',</br>';
									$shipment.=$item['City'].',</br>';
									$shipment.=$item['State'].',</br>';
									$shipment.=$item['Zip_Code'].'.</br>';
								}
								else{
									$shipment = "Not shipped";
								}
								echo "
								<li class='cart_item clearfix'>
									<div class='cart_item_image'>
									<img alt='$name' src='data:image/png;base64,$image'/></div>
									<div class='cart_item_info d-flex flex-md-row flex-column justify-content-between'>
										<div class='cart_item_name cart_info_col'>
											<div class='cart_item_title'>Name</div>
											<div class='cart_item_text'>$name</div>
										</div>
										<div class='cart_item_quantity cart_info_col'>
											<div class='cart_item_title'>Quantity</div>
											<div class='cart_item_text'>
												$Quantity
											</div>
										</div>
										<div class='cart_item_price cart_info_col'>
											<div class='cart_item_title'>Unit Price</div>
											<div class='cart_item_text'>$unit_Price</div>
										</div>
										<div class='cart_item_price cart_info_col'>
											<div class='cart_item_title'>Total</div>
											<div class='cart_item_text'>$Total</div>
										</div>
										<div class='cart_item_price cart_info_col'>
											<div class='cart_item_title'>Payment</div>
											<div class='cart_item_text'>$payment_status</div>
										</div>
										<div class='cart_item_price cart_info_col'>
											<div class='cart_item_title'>Shipment</div>
											<div class='cart_item_text'>$shipment</div>
										</div>
										
									</div>
								</li>";
							}
						}
						if (mysqli_num_rows($items)==0){
							echo "<li><div style='text-align:center' class='order_total_content'>Nothing to Display!</div></li>";
						}?>
							</ul>
					</div>



					<div class="cart_buttons">
					</div>
				</div>
			</div>
		</div>
	</div>
<?php require_once 'footer.php';?>