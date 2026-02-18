import 'package:flutter/material.dart';
import 'main.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    var user = UserSession.userData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ===== WELCOME CARD =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle,
                    size: 60, color: Colors.white),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${user?['full_name']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// ===== TITLE =====
          const Center(
            child: Column(
              children: [
                Text(
                  "Sistem Pendukung Keputusan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Metode Simple Additive Weighting (SAW)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// ===== INFO CARDS =====
          Row(
            children: [

              Expanded(
                child: _infoCard(
                  icon: Icons.rule,
                  title: "Kriteria",
                  desc: "Kelola bobot penilaian",
                  color: Colors.blue,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: _infoCard(
                  icon: Icons.school,
                  title: "Alternatif",
                  desc: "Data siswa",
                  color: Colors.purple,
                ),
              ),

            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: _infoCard(
                  icon: Icons.assignment,
                  title: "Penilaian",
                  desc: "Input nilai siswa",
                  color: Colors.orange,
                ),
              ),

              Expanded(
                child: _infoCard(
                  icon: Icons.bar_chart,
                  title: "Perankingan",
                  desc: "Proses SAW",
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 15),

            ],
          ),

          const SizedBox(height: 30),

          /// ===== SYSTEM DESCRIPTION =====
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                "Sistem ini membantu menentukan peringkat siswa terbaik "
                "berdasarkan kriteria yang telah ditentukan menggunakan "
                "metode Simple Additive Weighting (SAW).",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),


        ],
      ),
    );
  }

  /// ===== CARD WIDGET =====
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
