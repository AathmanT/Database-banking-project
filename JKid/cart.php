<?php
require_once 'header.php';
$query = "SELECT * FROM Cart NATURAL JOIN Product_Variant NATURAL JOIN Product WHERE customer_ID='$customer_ID'";
$items = mysqli_query($conn, $query);//||exit();
?>
	<div class="cart_section">
		<div class="container">
		<?php
			if(isset($_POST['submit'])){
				$cart_query="SELECT * FROM Cart NATURAL JOIN Product_Variant NATURAL JOIN Product WHERE customer_ID='$customer_ID'";
				$cart_result =  mysqli_query($conn, $cart_query);
				$date = date('Y-m-d H:i:s');
				$delivery_method = 'Home Delivery';
				$order_total= mysqli_fetch_row(mysqli_query($conn, "SELECT SUM(`unit_price`*`Quantity`) as sum FROM Cart NATURAL JOIN Product_Variant WHERE customer_ID='$customer_ID' limit 1"))[0];
				mysqli_autocommit($conn, FALSE);
				$query ="INSERT INTO orders (Total_Price,Order_date,Delivery_Method,customer_ID) VALUES ('$order_total', '$date','$delivery_method','$customer_ID'); SELECT @order_ID:=LAST_INSERT_ID() FROM orders; ";
				while($row = mysqli_fetch_assoc($cart_result)){
						$SKU = $row['SKU'];
						$query.= "insert into order_detail values ('$SKU',@order_ID,(select Quantity from cart "
						."where customer_ID='$customer_ID' and SKU='$SKU' LIMIT 1)); "
						."UPDATE product_variant "
						."set Stock = Stock - "
							."(select Quantity from cart "
							."where customer_ID='$customer_ID' and SKU='$SKU' LIMIT 1) "
						."where SKU='$SKU'; "
						."DELETE from cart where customer_ID='$customer_ID' and SKU='$SKU'; ";
				}
				@mysqli_multi_query($conn, $query);
				if(!mysqli_commit($conn)){
					echo 'Order Created Successfully!';
					echo'<meta http-equiv="refresh" content="0;url=checkout.php">';
				}
				else{
					echo 'Something went Wrong! Try again Later!';
				}
				mysqli_autocommit($conn, TRUE);
			}
			else{
		?>
				<div class="row">
					<div class="col-lg-10 offset-lg-1">
						<div class="cart_container">
							<div class="cart_title">Shopping Cart</div>
							<div class="cart_items">
								<ul class="cart_list">
								<?php
									$sum = 0;
									while($item = mysqli_fetch_assoc($items)){
										$image = base64_encode($item['Image']);
										$name = $item['product_name'];
										$SKU=$item['SKU'];
										$temp = mysqli_query($conn, "SELECT * FROM `variant_detail` WHERE `SKU`='$SKU'");
										$variant="";
										while($row=mysqli_fetch_assoc($temp)){
											$variant=$variant.$row['Attribute_Value'].", ";
										}
										
										$quantity = $item['Quantity'];
										$unit_Price = $item['unit_Price'];
										$total = $quantity*$unit_Price;
										$sum+=$total;
										echo "
										<li class='cart_item clearfix'>
											<div class='cart_item_image'>
											<img alt='$name' src='data:image/png;base64,$image'/></div>
											<div class='cart_item_info d-flex flex-md-row flex-column justify-content-between'>
												<div class='cart_item_name cart_info_col'>
													<div class='cart_item_title'>Name</div>
													<div class='cart_item_text'>$name</div>
												</div>
												<div class='cart_item_color cart_info_col'>
													<div class='cart_item_title'>Variant</div>
													<div class='cart_item_text'><span style='background-color:#999999;'></span>$variant</div>
												</div>
												<div class='cart_item_quantity cart_info_col'>
													<div class='cart_item_title'>Quantity</div>
													<div class='cart_item_text'>$quantity</div>
												</div>
												<div class='cart_item_price cart_info_col'>
													<div class='cart_item_title'>Price</div>
													<div class='cart_item_text'>$unit_Price</div>
												</div>
												<div class='cart_item_total cart_info_col'>
													<div class='cart_item_title'>Total</div>
													<div class='cart_item_text'>$total</div>
												</div>
											</div>
										</li>";
									}?>
									</ul>
							</div>
							
							<!-- Order Total -->
							<div class="order_total">
								<div class="order_total_content text-md-right">
									<div class="order_total_title">Order Total:</div>
									<div class="order_total_amount"><?php echo $sum;?></div>
								</div>
							</div>

							<div class="cart_buttons">
								<form method="post" action="cart.php">
									<input type="submit" name="submit" class="button cart_button_checkout" value="CheckOut" onclick="submit">
								</form>
							</div>
						</div>
					</div>
				</div>
			<?php }?>
		</div>
	</div>
<?php require_once 'footer.php';?>