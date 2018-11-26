<?php
	if(isset($_GET['signout'])&&$_GET['signout']=='true'){
		setcookie("guest", "", time() - 3600);
		setcookie("user", "", time() - 3600);
		setcookie("pass", "", time() - 3600);
		echo '<meta http-equiv="refresh" content="0;url=index.php">';
	}
	$customer_ID = isset($_COOKIE['guest'])?$_COOKIE['guest']:null || isset($_COOKIE['user'])?$_COOKIE['user']:null;
	if(!(isset($_COOKIE['guest'])||isset($_COOKIE['user'])&&isset($_COOKIE['pass']))){
		echo '<meta http-equiv="refresh" content="0;url=index.php">';
		exit();
	}
	$conn = mysqli_connect("localhost", "root", "", "angaadi");
	$cart_page = "cart.php";
?>
<html lang="en">
<head>
<title>Cart</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="OneTech shop project">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="styles/bootstrap4/bootstrap.min.css">
<link href="plugins/fontawesome-free-5.0.1/css/fontawesome-all.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="styles/cart_styles.css">
<link rel="stylesheet" type="text/css" href="styles/cart_responsive.css">

</head>

<body>

<div class="super_container">

	<!-- Header -->
	
	<header class="header">

		<!-- Top Bar -->

		<div class="top_bar">
			<div class="container">
				<div class="row">
					<div class="col d-flex flex-row">
						<div class="top_bar_contact_item"><div class="top_bar_icon"><img src="images/phone.png" alt=""></div>+94 110000000</div>
						<div class="top_bar_contact_item">
							<div class="top_bar_icon"><img src="images/mail.png" alt=""></div><a href="mailto:angaadi@gmail.com">angaadi@gmail.com</a></div>
						<div class="top_bar_content ml-auto">
							<div class="top_bar_menu">
					
							</div>
							<div class="top_bar_user">
								<b><a href='orders.php'>Orders</a></b>
							</div>
							<div class="top_bar_user">
								<b><a href='?signout=true'>Sign Out</a></b>
							</div>
						</div>
					</div>
				</div>
			</div>		
		</div>

		<!-- Header Main -->

		<div class="header_main">
			<div class="container">
				<div class="row">

					<!-- Logo -->
					<div class="col-lg-2 col-sm-3 col-3 order-1">
						<div class="logo_container">
							<div class="logo"><a href="index.php">OneTech</a></div>
						</div>
					</div>

					<!-- Search -->
					<div class="col-lg-6 col-12 order-lg-2 order-3 text-lg-left text-right">
						<div class="header_search">
							<div class="header_search_content">
								<div class="header_search_form_container">
									<form action="products.php" class="header_search_form clearfix">
										<input type="search" name='search' required="required" class="header_search_input" placeholder="Search for products...">
										<div class="custom_dropdown">
											<div class="custom_dropdown_list">
												<span class="custom_dropdown_placeholder clc">All Categories</span>
												<i class="fas fa-chevron-down"></i>
												<ul class="custom_list clc">
													<li><a class="clc" href="products.php?category=All Categories">All Categories</a></li>
													<?php
														$result = mysqli_query($conn,"SELECT DISTINCT `category_name` FROM `category`");
														while($row = mysqli_fetch_row($result)){
															$cat=$row[0];
															echo "<li><a href='products.php?category=$cat' class='clc' >$cat</a></li>";
														}
													?>
												</ul>
											</div>
										</div>
										<button type="submit" class="header_search_button trans_300" value="Submit"><img src="images/search.png" alt=""></button>
									</form>
								</div>
							</div>
						</div>
					</div>

					<!-- Wishlist -->
					<div class="col-lg-4 col-9 order-lg-3 order-2 text-lg-left text-right">
						<div class="wishlist_cart d-flex flex-row align-items-center justify-content-end">
					<!-- Cart -->
							<div class="cart">
								<div class="cart_container d-flex flex-row align-items-center justify-content-end">
									<div class="cart_icon">
										<img src="images/cart.png" alt="">
										<div class="cart_count"><span>
										<?php echo mysqli_fetch_row(mysqli_query($conn,"SELECT COUNT(customer_ID) FROM cart WHERE customer_ID='$customer_ID'"))[0]; ?></span></div>
									</div>
									<div class="cart_content">
										<div class="cart_text"><a href="cart.php">Cart</a></div>
										<div class="cart_price"></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- Main Navigation -->

		<nav class="main_nav">
			<div class="container">
				<div class="row">
					<div class="col">
						
						<div class="main_nav_content d-flex flex-row">

							<!-- Categories Menu -->

							<div class="cat_menu_container">
								<div class="cat_menu_title d-flex flex-row align-items-center justify-content-start">
									<div class="cat_burger"><span></span><span></span><span></span></div>
									<div class="cat_menu_text">categories</div>
								</div>

								<ul class="cat_menu">
								<?php
									$result = mysqli_query($conn,"SELECT DISTINCT category_name FROM category");
									while($row = mysqli_fetch_row($result)){
										$cat=$row[0];
										echo "<li class='hassubs'>"
											."<a href='products.php?category=$cat'>$cat<i class='fas fa-chevron-right'></i></a>"
											."<ul>";
												$subresult = mysqli_query($conn,"SELECT `sub_category_name` FROM `category` WHERE `category_name`='$cat'");
												while($subrow = mysqli_fetch_row($subresult)){
													$subcat = $subrow[0];
													echo "<li><a href='products.php?subcategory=$subcat'>$subcat<i class='fas fa-chevron-right'></i></a></li>";
												}
										echo"</ul></li>";
									}
								?>
								</ul>
							</div>

							
							<!-- Main Nav Menu -->

							<div class="main_nav_menu ml-auto">
								
							</div>

							<!-- Menu Trigger -->

							<div class="menu_trigger_container ml-auto">
								<div class="menu_trigger d-flex flex-row align-items-center justify-content-end">
									<div class="menu_burger">
										<div class="menu_trigger_text">menu</div>
										<div class="cat_burger menu_burger_inner"><span></span><span></span><span></span></div>
									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</nav>
	</header>