import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../AdminScreen.dart';

Future<void> showAdminLoginDialog(BuildContext context) async {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final response = await ApiService.login(
                        usernameController.text,
                        passwordController.text,
                      );

                      Navigator.pop(context);

                      if (response != null &&
                          response['message'] == "Login successful") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminScreen()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Text(
                              "Login Failed",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            content: Text(
                              response?['message'] ?? "Unknown error",
                              style: TextStyle(color: Colors.black87),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
