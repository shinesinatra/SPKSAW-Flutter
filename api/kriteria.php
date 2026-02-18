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
$action = $_GET['action'] ?? '';
function generateField($nama){
    preg_match('/\d+/', $nama, $match);
    if(isset($match[0])){
        return $match[0];
    }
    $clean = strtolower($nama);
    $clean = preg_replace('/[^a-z0-9]/', '_', $clean);
    return $clean;
}

//get data
if($action == "get"){
    $data = mysqli_query($conn,"SELECT * FROM kriteria ORDER BY kode ASC");
    $result = [];
    while($row = mysqli_fetch_assoc($data)){
        $result[] = $row;
    }
    echo json_encode($result);
}

//ad data
if($action == "add"){
    $kode  = $_POST['kode'];
    $nama  = $_POST['nama'];
    $bobot = $_POST['bobot'];
    mysqli_query($conn,"INSERT INTO kriteria(kode,nama,bobot) VALUES('$kode','$nama','$bobot')");
    $field = generateField($nama);
    $check = mysqli_query($conn,"
        SELECT COLUMN_NAME 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME='penilaian' 
        AND COLUMN_NAME='$field'
        AND TABLE_SCHEMA = DATABASE()
    ");
    if(mysqli_num_rows($check) == 0){
        mysqli_query($conn,"ALTER TABLE penilaian ADD $field DOUBLE DEFAULT 0");
    }
    echo json_encode(["status"=>"success"]);
}

//update data
if($action == "update"){
    $kode  = $_POST['kode'];
    $nama  = $_POST['nama'];
    $bobot = $_POST['bobot'];
    $old = mysqli_fetch_assoc(
        mysqli_query($conn,"SELECT nama FROM kriteria WHERE kode='$kode'")
    );
    $oldField = generateField($old['nama']);
    $newField = generateField($nama);
    mysqli_query($conn,"UPDATE kriteria SET nama='$nama', bobot='$bobot' WHERE kode='$kode'");
    if($oldField != $newField){
        $check = mysqli_query($conn,"
            SELECT COLUMN_NAME 
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME='penilaian' 
            AND COLUMN_NAME='$newField'
            AND TABLE_SCHEMA = DATABASE()
        ");
        if(mysqli_num_rows($check) == 0){
            mysqli_query($conn,"ALTER TABLE penilaian CHANGE $oldField $newField DOUBLE DEFAULT 0");
        }
    }
    echo json_encode(["status"=>"updated"]);
}

//delete data
if($action == "delete"){
    $kode = $_POST['kode'];
    $old = mysqli_fetch_assoc(
        mysqli_query($conn,"SELECT nama FROM kriteria WHERE kode='$kode'")
    );
    $field = generateField($old['nama']);
    mysqli_query($conn,"DELETE FROM kriteria WHERE kode='$kode'");
    $check = mysqli_query($conn,"
        SELECT COLUMN_NAME 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME='penilaian' 
        AND COLUMN_NAME='$field'
        AND TABLE_SCHEMA = DATABASE()
    ");
    if(mysqli_num_rows($check) > 0){
        mysqli_query($conn,"ALTER TABLE penilaian DROP COLUMN $field");
    }
    echo json_encode(["status"=>"deleted"]);
}
?>