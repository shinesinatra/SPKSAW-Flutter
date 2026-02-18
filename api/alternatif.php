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

//get data
if($action == "get"){
    $data = mysqli_query($conn,"SELECT * FROM siswa ORDER BY nama ASC");
    $result = [];
    while($row = mysqli_fetch_assoc($data)){
        $result[] = $row;
    }
    echo json_encode($result);
}

//add data
if($action == "add"){
    $nisn = $_POST['nisn'];
    $kelas = $_POST['kelas'];
    $nama = $_POST['nama'];
    $tanggal_lahir = $_POST['tanggal_lahir'];
    $jenis_kelamin = $_POST['jenis_kelamin'];
    $alamat = $_POST['alamat'];
    mysqli_query($conn,"INSERT INTO siswa 
        (nisn,kelas,nama,tanggal_lahir,jenis_kelamin,alamat)
        VALUES('$nisn','$kelas','$nama','$tanggal_lahir','$jenis_kelamin','$alamat')
    ");
    echo json_encode(["status"=>"success"]);
}

//update data
if($action == "update"){
    $nisn = $_POST['nisn'];
    $kelas = $_POST['kelas'];
    $nama = $_POST['nama'];
    $tanggal_lahir = $_POST['tanggal_lahir'];
    $jenis_kelamin = $_POST['jenis_kelamin'];
    $alamat = $_POST['alamat'];
    mysqli_query($conn,"UPDATE siswa SET
        kelas='$kelas',
        nama='$nama',
        tanggal_lahir='$tanggal_lahir',
        jenis_kelamin='$jenis_kelamin',
        alamat='$alamat'
        WHERE nisn='$nisn'
    ");
    echo json_encode(["status"=>"updated"]);
}

//delete data
if($action == "delete"){
    $nisn = $_POST['nisn'];
    mysqli_query($conn,"DELETE FROM siswa WHERE nisn='$nisn'");
    echo json_encode(["status"=>"deleted"]);
}
?>