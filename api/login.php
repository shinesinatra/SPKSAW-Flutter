<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
include "connection.php";
$username = $_POST['username'];
$password = $_POST['password'];
$query = mysqli_query($conn, "
SELECT * FROM users 
WHERE username='$username' OR email='$username'
");
if(mysqli_num_rows($query) > 0){
    $user = mysqli_fetch_assoc($query);
    if(password_verify($password, $user['password'])){
        echo json_encode([
            "success" => true,
            "user" => $user
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Password Salah"
        ]);
    }
}else{
    echo json_encode([
        "success" => false,
        "message" => "Username / Email Salah"
    ]);
}
?>