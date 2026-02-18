import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'menu.dart';
import 'forgot_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class UserSession {
  static Map<String, dynamic>? userData;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool hidePass = true;
  bool loading = false;

  Future login() async {
    setState(() => loading = true);

    var url = Uri.parse(
      "http://localhost/FlutterProjects/spksaw/api/login.php",
    );

    var response = await http.post(
      url,
      body: {"username": username.text, "password": password.text},
    );

    if (!mounted) return; // 🔑 FIX

    var data = json.decode(response.body);

    setState(() => loading = false);

    if (data["success"]) {
      UserSession.userData = data["user"];

      if (!mounted) return; // 🔑 FIX

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuPage()),
      );
    } else {
      if (!mounted) return; // 🔑 FIX

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text("Login | Aplikasi"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: username,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Username / Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: password,
                        obscureText: hidePass,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidePass
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => hidePass = !hidePass);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.help_outline),
                          label: const Text("Lupa Password"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : login,
                          icon: const Icon(Icons.login),
                          label: const Text("Masuk"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
