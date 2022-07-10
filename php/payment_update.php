<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$name = $_GET['name'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
    $status = "Paid";
}else{
    $paidstatus = "Failed";
    $status = "Failed";
}
$payment_id = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-IOCn__FV88jmogvkzHwioA');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
        $sqpupdatecart = "UPDATE `tbl_cart` SET `payment_status`='paid',`payment_id`='$payment_id' WHERE user_email='$email' AND payment_status IS NULL";
        if ($conn->query($sqpupdatecart)){
            $message = "Payment completed. Return back to the application by pressing the back button on the app task bar.";
            $amount = number_format((float)$amount, 2, '.', '');
            printTable($payment_id,$name,$email,$amount,$paidstatus,$message);   
        }else{
            $message = "Payment incompleted. Return back to the application by pressing the back button on the app task bar and perform the payment again.";
            printTable('Failed',$name,$email,$amount,$paidstatus,$message);
        }
    }else{
        $message = "Payment incompleted. Return back to the application by pressing the back button on the app task bar and perform the payment again.";
        printTable('Failed',$name,$email,$amount,$paidstatus,$message);
    }
}

function printTable($payment_id,$name,$email,$amount,$paidstatus,$message){
   echo "
        <html>
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1'>
            <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
        </head>
        <div = class='w3-padding w3-container w3-block w3-green' > <h4>Thank you for your payment</h4>
        <p>The following is your receipt</p></div>
        <div class='w3-container'>
            <table class='w3-table w3-striped w3-bordered'>
            <tr><th>Receipt ID</th><td>$payment_id<td></tr>
            <tr><th>Paid By</th><td>$name<td></tr>
            <tr><th>Email</th><td>$email<td></tr>
            <tr><th>Amount </th><td>RM $amount<td></tr>
            <tr><th>Payment Status</th><td>$paidstatus<td></tr>
            </table>
        <hr>
        <div class='w3-container w3-round w3-block w3-green'>$message</div>
        </div>
        </body></html> 
        ";
}

?>