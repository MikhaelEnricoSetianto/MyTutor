<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$useremail = $_POST['email'];
$sqlloadcart = "SELECT tbl_cart.cart_id, tbl_cart.subject_id, tbl_cart.cart_qty, tbl_subjects.subject_name, tbl_subjects.subject_price FROM tbl_cart 
INNER JOIN tbl_subjects ON tbl_cart.subject_id = tbl_subjects.subject_id WHERE tbl_cart.user_email = '$useremail' AND tbl_cart.payment_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    $total_payable = 0;
    $carts["cart"] = array();
    while ($rows = $result->fetch_assoc()) {
        
        $sublist = array();
        $sublist['cart_id'] = $rows['cart_id'];
        $sublist['subject_name'] = $rows['subject_name'];
        $subprice = $rows['subject_price'];
        $sublist['price'] = number_format((float)$subprice, 2, '.', '');
        $sublist['cart_qty'] = $rows['cart_qty'];
        $sublist['subject_id'] = $rows['subject_id'];
        $price = $rows['cart_qty'] * $subprice;
        $total_payable = $total_payable + $price;
        $sublist['totalprice'] = number_format((float)$price, 2, '.', ''); 
        array_push($carts["cart"],$sublist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>