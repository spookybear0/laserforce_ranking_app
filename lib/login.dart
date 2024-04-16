import "dart:convert";
import "package:flutter/material.dart";
import "package:laserforce_ranking_app/api.dart";
import "package:laserforce_ranking_app/main.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController codenameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: codenameController,
                decoration: const InputDecoration(
                  labelText: "Codename",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  LaserforceApi.login(
                          codenameController.text, passwordController.text)
                      .then((response) {
                    print("Response status: ${response.statusCode}");
                    print("Response body: ${response.body}");
                    var jsonResponse = jsonDecode(response.body);

                    if (response.statusCode == 200 &&
                        jsonResponse["status"] == "ok") {
                      print("Login successful");

                      final storage = FlutterSecureStorage();
                      storage.write(
                          key: "codename", value: codenameController.text);
                      storage.write(
                          key: "password", value: passwordController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  });
                },
                child: Text("Login"),
              ),
              // TODO: make it so people can claim ownership of their profile
            ],
          ),
        ),
      ),
    );
  }
}
