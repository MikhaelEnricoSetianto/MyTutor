<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
    include 'dbconnect.php';
    $email = addslashes($_POST['email']);
    $password = $_POST['password'];
    $sqllogin = "SELECT * FROM mytutor WHERE email = '$email' AND pass_word = '$password'";
    $result = $conn->query($sqllogin);
    $numrow = $result->num_rows;

    if ($numrow > 0) {
        while ($row = $result->fetch_assoc()) {
            $user['id'] = $row['id'];
            $user['name'] = $row['name'];
            $user['email'] = $row['email'];
            $user['password'] = $row['pass_word'];
            $user['phonenumber'] = $row['phonenumber'];
            $user['address'] = $row['address'];
        }
            $response = array('status' => 'success', 'data' => $user);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
            die();
        }
        function sendJsonResponse($sentArray)
        {
            header('Content-Type: application/json');
            echo json_encode($sentArray);
        }    
?>    