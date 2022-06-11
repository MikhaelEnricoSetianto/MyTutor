<?php
include("dbconnect.php");
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$limit = 5;
$page = (isset($_POST['page']) && is_numeric($_POST['page'])) ? $_POST['page'] : 1;
$pageStart = ($page - 1) * $limit;
$sqlselectSubject = "SELECT * FROM tbl_subjects LIMIT $pageStart, $limit";
$stmt = $conn->prepare($sqlselectSubject);
$stmt->execute();
$result = $stmt->get_result();

$sql = $conn->query("SELECT count(subject_id) AS id FROM tbl_subjects")->fetch_assoc();
$allRecords = $sql['id'];
$totalPages = ceil($allRecords / $limit);
$prev = $page - 1;
$next = $page + 1;

if ($allRecords > 0) {
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