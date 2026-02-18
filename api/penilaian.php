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
    $penilaian = [];
    $kriteria = [];
    $kelas = [];
    $q1 = mysqli_query($conn,"SELECT * FROM penilaian");
    while($row = mysqli_fetch_assoc($q1)){
        $penilaian[] = $row;
    }
    $q2 = mysqli_query($conn,"SELECT * FROM kriteria ORDER BY kode ASC");
    while($row = mysqli_fetch_assoc($q2)){
        $row['field'] = generateField($row['nama']);
        $kriteria[] = $row;
    }
    $q3 = mysqli_query($conn,"SELECT DISTINCT kelas FROM siswa ORDER BY kelas ASC");
    while($row = mysqli_fetch_assoc($q3)){
        $kelas[] = $row['kelas'];
    }
    echo json_encode([
        "penilaian" => $penilaian,
        "kriteria"  => $kriteria,
        "kelas"     => $kelas
    ]);
}

if($action == "getSiswa"){
    $kelas = $_POST['kelas'];
    $result = [];
    $q = mysqli_query($conn,"SELECT nisn,nama FROM siswa WHERE kelas='$kelas'");
    while($row = mysqli_fetch_assoc($q)){
        $result[] = $row;
    }
    echo json_encode($result);
}

//add penilaian
if($action == "add"){
    $nisn  = $_POST['nisn'];
    $kelas = $_POST['kelas'];
    $nama  = $_POST['nama'];
    $kriteria = mysqli_query($conn,"SELECT nama FROM kriteria");
    $fields = [];
    $values = [];
    while($k = mysqli_fetch_assoc($kriteria)){
        $field = generateField($k['nama']);
        $fields[] = $field;
        $values[] = $_POST[$field] ?? 0;
    }
    $fieldString = implode(",", $fields);
    $valueString = implode(",", $values);
    mysqli_query($conn,"
        INSERT INTO penilaian (kelas,nisn,nama,$fieldString)
        VALUES('$kelas','$nisn','$nama',$valueString)
    ");
    echo json_encode(["status"=>"success"]);
}

//update penilaian
if($action == "update"){
    $nisn  = $_POST['nisn'];
    $kelas = $_POST['kelas'];
    $nama  = $_POST['nama'];
    $kriteria = mysqli_query($conn,"SELECT nama FROM kriteria");
    $set = [];
    while($k = mysqli_fetch_assoc($kriteria)){
        $field = generateField($k['nama']);
        $nilai = $_POST[$field] ?? 0;
        $set[] = "$field='$nilai'";
    }
    $setString = implode(",", $set);
    mysqli_query($conn,"
        UPDATE penilaian 
        SET kelas='$kelas',
            nama='$nama',
            $setString
        WHERE nisn='$nisn'
    ");
    echo json_encode(["status"=>"updated"]);
}

//delete penilaian
if($action == "delete"){
    $nisn = $_POST['nisn'];
    mysqli_query($conn,"DELETE FROM penilaian WHERE nisn='$nisn'");
    echo json_encode(["status"=>"deleted"]);
}
?>