<?php
include "connection.php";

$message = "";

if(isset($_POST['submit'])){

    $nik        = $_POST['nik'];
    $username   = $_POST['username'];
    $full_name  = $_POST['full_name'];
    $phone      = $_POST['phone_number'];
    $email      = $_POST['email'];
    $password   = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $check = mysqli_query($conn, "
        SELECT * FROM users 
        WHERE username='$username' OR email='$email'
    ");

    if(mysqli_num_rows($check) > 0){
        $message = "Username atau Email sudah digunakan!";
    } else {

        $insert = mysqli_query($conn, "
            INSERT INTO users
            (nik, username, full_name, phone_number, email, password)
            VALUES
            ('$nik','$username','$full_name','$phone','$email','$password')
        ");

        if($insert){
            $message = "Akun berhasil ditambahkan!";
        } else {
            $message = "Gagal menambahkan akun!";
        }
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Tambah Akun</title>
    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
            padding: 40px;
        }
        .card {
            width: 400px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
        }
        button {
            width: 100%;
            padding: 12px;
            background: green;
            color: white;
            border: none;
        }
        .msg {
            text-align: center;
            margin-bottom: 10px;
            color: blue;
        }
    </style>
</head>
<body>

<div class="card">
    <h2>Tambah Akun User</h2>

    <?php if($message != ""): ?>
        <div class="msg"><?= $message ?></div>
    <?php endif; ?>

    <form method="POST">

        <input type="text" name="nik" placeholder="NIK" required>
        <input type="text" name="username" placeholder="Username" required>
        <input type="text" name="full_name" placeholder="Full Name" required>
        <input type="text" name="phone_number" placeholder="Phone Number">
        <input type="email" name="email" placeholder="Email">
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit" name="submit">Tambah Akun</button>

    </form>
</div>

</body>
</html>
