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
$sqlselectTutor = "SELECT * FROM tbl_tutors LIMIT $pageStart, $limit";
$stmt = $conn->prepare($sqlselectTutor);
$stmt->execute();
$result = $stmt->get_result();

$sql = $conn->query("SELECT count(tutor_id) AS id FROM tbl_tutors")->fetch_assoc();
$allRecords = $sql['id'];
$totalPages = ceil($allRecords / $limit);
$prev = $page - 1;
$next = $page + 1;

if ($allRecords > 0) {
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