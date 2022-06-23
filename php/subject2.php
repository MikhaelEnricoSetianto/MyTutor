<?php
include("dbconnect.php");
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$results_per_page = 5;
$page = (int)$_POST['page']??1;
$search = $_POST['search'];


$page_first_result = ($page - 1) * $results_per_page;
$sqlloadsubject = "SELECT * FROM tbl_subjects WHERE subject_name LIKE '%$search%' ORDER BY subject_id ASC";
$result = $conn->query($sqlloadsubject);
$number_of_result = $result->num_rows;
$totalPages = ceil($number_of_result / $results_per_page);
$sqlloadsubject = $sqlloadsubject . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadsubject);

if ($result->num_rows > 0) {
    $subjects['subjects'] = array();
    while ($row = $result->fetch_assoc()) {
        $sublist = array();
        $sublist['subject_id'] = $row['subject_id'];
        $sublist['subject_name'] = $row['subject_name'];
        $sublist['subject_description'] = $row['subject_description'];
        $sublist['subject_price'] = $row['subject_price'];
        $sublist['subject_sessions'] = $row['subject_sessions'];
        $sublist['subject_rating'] = $row['subject_rating'];
        array_push($subjects['subjects'], $sublist);
    }
    $response = array('status' => 'success', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => $subjects);
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