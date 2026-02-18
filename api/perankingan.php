<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
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

if ($action == "get_kelas") {
    $kelas = [];
    $q = mysqli_query($conn, "SELECT DISTINCT kelas FROM penilaian ORDER BY kelas ASC");
    while($d = mysqli_fetch_assoc($q)){
        $kelas[] = $d['kelas'];
    }
    echo json_encode($kelas);
    exit();
}
if ($action == "reset") {
    mysqli_query($conn, "TRUNCATE TABLE perankingan");
    echo json_encode(["success"=>true]);
    exit();
}

//proses saw
if ($action == "proses") {
    $kelas = $_GET['kelas'] ?? '';
    if ($kelas == '') {
        echo json_encode([]);
        exit();
    }
    mysqli_query($conn, "TRUNCATE TABLE perankingan");
    $columns = [];
    $qcol = mysqli_query($conn, "SHOW COLUMNS FROM penilaian");
    while($c = mysqli_fetch_assoc($qcol)){
        $columns[] = $c['Field'];
    }
    $kriteria = [];
    $max = [];
    $qk = mysqli_query($conn, "SELECT * FROM kriteria");
    while($k = mysqli_fetch_assoc($qk)){
        $field = generateField($k['nama']);
        if(!in_array($field, $columns)){
            continue;
        }
        $kriteria[] = [
            'field' => $field,
            'bobot' => $k['bobot']
        ];
        $qmax = mysqli_query($conn,"
            SELECT MAX(`$field`) as max_val
            FROM penilaian
            WHERE kelas='$kelas'
        ");
        $dmax = mysqli_fetch_assoc($qmax);
        $max[$field] = $dmax['max_val'] ?: 1;
    }
    $siswa = [];
    $qs = mysqli_query($conn, "
        SELECT * FROM penilaian
        WHERE kelas='$kelas'
    ");
    while($s = mysqli_fetch_assoc($qs)){
        $siswa[] = $s;
    }
    if(count($siswa)==0){
        echo json_encode([]);
        exit();
    }
    $hasil = [];
    foreach($siswa as $s){
        $nilai_saw = 0;
        foreach($kriteria as $k){
            $field = $k['field'];
            $bobot = $k['bobot'];
            $nilai = isset($s[$field]) ? $s[$field] : 0;
            $max_k = $max[$field];
            $rij = $nilai / $max_k;
            $nilai_saw += $rij * $bobot;
        }
        $hasil[] = [
            "nisn"  => $s['nisn'],
            "nama"  => $s['nama'],
            "nilai" => round($nilai_saw,4)
        ];
    }
    usort($hasil,function($a,$b){
        return $b['nilai'] <=> $a['nilai'];
    });
    foreach($hasil as $h){
        mysqli_query($conn,"
            INSERT INTO perankingan (nisn,nama,nilai)
            VALUES (
                '{$h['nisn']}',
                '{$h['nama']}',
                '{$h['nilai']}'
            )
        ");
    }
    echo json_encode($hasil);
    exit();
}

//get hasil
$q = mysqli_query($conn,"SELECT * FROM perankingan ORDER BY nilai DESC");
$data=[];
while($d=mysqli_fetch_assoc($q)){
    $data[]=$d;
}
echo json_encode($data);
?>