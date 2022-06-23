<?php
include("dbconnect.php");
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$results_per_page = 5;
$page = (int)$_POST['page'];

$page_first_result = ($page - 1) * $results_per_page;
$sqlloadtutor = "SELECT * FROM tbl_tutors";
$result = $conn->query($sqlloadtutor);
$number_of_result = $result->num_rows;
$totalPages = ceil($number_of_result / $results_per_page);
$sqlloadtutor = $sqlloadtutor . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadtutor);


if ($result->num_rows > 0) {
    $tutors['tutors'] = array();
    while ($row = $result->fetch_assoc()) {
        $tutlist = array();
        $tutlist['tutor_id'] = $row['tutor_id'];
        $tutlist['tutor_email'] = $row['tutor_email'];
        $tutlist['tutor_phone'] = $row['tutor_phone'];
        $tutlist['tutor_name'] = $row['tutor_name'];
        $tutlist['tutor_description'] = $row['tutor_description'];
        array_push($tutors['tutors'], $tutlist);
    }
    $response = array('status' => 'success', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => $tutors);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>