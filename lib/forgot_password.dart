import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text("Lupa Password"),
        ),
      ),
      body: const Center(child: Text("Fitur reset password")),
    );
  }
}
