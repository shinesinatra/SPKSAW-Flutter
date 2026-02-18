-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 18 Feb 2026 pada 10.01
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flutter_spksaw`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `kriteria`
--

CREATE TABLE `kriteria` (
  `kode` varchar(10) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `bobot` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kriteria`
--

INSERT INTO `kriteria` (`kode`, `nama`, `bobot`) VALUES
('C1', 'Nilai Rata Rata Rapor', 0.3),
('C2', 'Presentase Kehadiran', 0.2),
('C3', 'Penilaian Sikap Perilaku', 0.2),
('C4', 'Keaktifan Ekstrakulikuler', 0.15),
('C5', 'Keaktifan Kompetisi Lomba', 0.15);

-- --------------------------------------------------------

--
-- Struktur dari tabel `penilaian`
--

CREATE TABLE `penilaian` (
  `kelas` varchar(10) NOT NULL,
  `nisn` varchar(20) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `nilai_rata_rata_rapor` double DEFAULT 0,
  `presentase_kehadiran` double DEFAULT 0,
  `penilaian_sikap_perilaku` double DEFAULT 0,
  `keaktifan_ekstrakulikuler` double DEFAULT 0,
  `keaktifan_kompetisi_lomba` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `perankingan`
--

CREATE TABLE `perankingan` (
  `nisn` varchar(50) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `nilai` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `nisn` varchar(20) NOT NULL,
  `kelas` varchar(5) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `jenis_kelamin` varchar(15) NOT NULL,
  `alamat` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `nik` varchar(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`nik`, `username`, `full_name`, `phone_number`, `email`, `password`) VALUES
('NIK123', 'admin', 'Administrator', '08123456789', 'admin@gmail.com', '$2y$10$qWG3kfOEuj2vTvcuqA.AqO/DHzgJfyNf0Ln1YWV1QolLSIrlnpgti');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `kriteria`
--
ALTER TABLE `kriteria`
  ADD PRIMARY KEY (`kode`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indeks untuk tabel `perankingan`
--
ALTER TABLE `perankingan`
  ADD PRIMARY KEY (`nisn`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`nisn`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`nik`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
