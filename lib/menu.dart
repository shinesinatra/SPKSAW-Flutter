import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'beranda.dart';
import 'kriteria.dart';
import 'alternatif.dart';
import 'penilaian.dart';
import 'perankingan.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  Widget currentPage = const BerandaPage();
  String dateTime = "";
  late Timer timer;

  @override
  void initState() {
    super.initState();
    updateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => updateTime());
  }

  void updateTime() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    setState(() {
      dateTime = DateFormat("EEEE, d MMMM yyyy HH:mm:ss", "id_ID").format(now);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void changePage(Widget page) {
    setState(() {
      currentPage = page;
    });
    Navigator.pop(context);
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hoverColor: Colors.green.shade50,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {

    final fullName = UserSession.userData?['full_name'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            dateTime,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [

            /// HEADER USER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// ICON USER (lebih kecil & elegan)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 26,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FULL NAME LOGIN
                  Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// MENU LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [

                  menuItem(
                    icon: Icons.home,
                    title: "Beranda",
                    onTap: () => changePage(const BerandaPage()),
                  ),

                  menuItem(
                    icon: Icons.list_alt,
                    title: "Kriteria",
                    onTap: () => changePage(const KriteriaPage()),
                  ),

                  menuItem(
                    icon: Icons.groups,
                    title: "Alternatif",
                    onTap: () => changePage(const AlternatifPage()),
                  ),

                  menuItem(
                    icon: Icons.assignment,
                    title: "Penilaian",
                    onTap: () => changePage(const PenilaianPage()),
                  ),

                  menuItem(
                    icon: Icons.bar_chart,
                    title: "Perankingan",
                    onTap: () => changePage(const PerankinganPage()),
                  ),

                  const Divider(height: 30),

                  menuItem(
                    icon: Icons.logout,
                    title: "Keluar",
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: currentPage,

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "© 2026 SPK SAW Application",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
