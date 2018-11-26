<?php
	require_once 'header.php';
	$conn = mysqli_connect("localhost", "root", "", "angaadi");
	if(isset($_POST['SKU'])&&isset($_POST['quantity'])){
		$SKU = $_POST['SKU'];
		$quantity =$_POST['quantity'];
		$date=date('Y-m-d H:i:s');
		$add_query = "insert into cart values('$date','$quantity','$SKU', '$customer_ID')";
		$success = mysqli_query($conn, $add_query);
		if($success){
			echo "<script type='text/javascript'>alert('Cart updated Successfully!');</script>";
		}
		else if(mysqli_num_rows(mysqli_query($conn, "select * from cart where SKU='$SKU'"))!=0){
			echo "<script type='text/javascript'>alert('Item already in Cart!');</script>";
		}
	}

	if(isset($_GET['search'])){
		$search = $_GET['search'];
		$query = "SELECT * FROM Product_Variant NATURAL JOIN Product WHERE product_name like '%$search%'";
	}
	else if(isset($_GET['category'])){
		$category = $_GET['category'];
		$query = "SELECT * FROM Product_Variant NATURAL JOIN Product NATURAL JOIN category_products NATURAL JOIN category WHERE category_name='$category'";
	}
	else if(isset($_GET['sub_category'])){
		$sub_catergory = $_GET['sub_category'];
		$query = "SELECT * FROM Product_Variant NATURAL JOIN Product NATURAL JOIN category_products WHERE sub_category_name='$sub_category'";
	}
	else{
		$query = "SELECT * FROM Product_Variant NATURAL JOIN Product";
	}
	$items = mysqli_query($conn, $query);//||exit();\
?>
	<div class="cart_section">
		<div class="container">
			<div class="row">
			<div class="col-lg-10 offset-lg-1">
					<div class="cart_items">
						<ul class="cart_list">
						<?php
						if($items){
							while($item = mysqli_fetch_assoc($items)){
								$image = base64_encode($item['Image']);
								$name = $item['product_name'];
								$SKU=$item['SKU'];
								$temp = mysqli_query($conn, "SELECT * FROM `variant_detail` WHERE `SKU`='$SKU'");
								$variant="";
								while($row=mysqli_fetch_assoc($temp)){
									$variant=$variant.$row['Attribute_Value'].", ";
								}
								
								$unit_Price = $item['unit_Price'];
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
										<div class='cart_item_price cart_info_col'>
											<div class='cart_item_title'>Price</div>
											<div class='cart_item_text'>$unit_Price</div>
										</div>
										<form method='post' action='products.php'>
											<div class='cart_item_quantity cart_info_col'>
												<div class='cart_item_title'>Quantity</div>
												<div class='cart_item_text'>
													<input type='number' name ='quantity' value = '1' style='width:40px;>
												</div>
											</div>
											<div class='cart_info_col'>
												<div class='cart_item_text'>
													<input type='submit' name ='submit' class='button cart_button_checkout' value='Add Cart' onclick='submit'>
												</div>
											</div>
											<input type='hidden' value='$SKU' name='SKU'>
										</form>
									</div>
								</li>";
							}
						}
						if (mysqli_num_rows($items)==0){
							echo "<li><div style='text-align:center' class='order_total_content'>Nothing to Display!</div></li>";
						}?>
							</ul>
					</div>

				</div>
			</div>
		</div>
	</div>
<?php require_once 'footer.php';?>