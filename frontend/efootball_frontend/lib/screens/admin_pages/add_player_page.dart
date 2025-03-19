import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddPlayerPage extends StatefulWidget {
  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _clubIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Text(
          "Add Player",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add New Player",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField("Club ID", _clubIdController),
                      _buildTextField("Player Name", _nameController),
                      _buildTextField("Password", _passwordController,
                          obscureText: true),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              color: Colors.white, // Submit button text is white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.indigo.shade50,
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          prefixIcon: Icon(
            obscureText ? Icons.lock : Icons.person,
            color: Colors.deepPurple,
          ),
        ),
        style: TextStyle(fontSize: 16, color: Colors.black87),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newPlayer = {
        'club_id': _clubIdController.text,
        'name': _nameController.text,
        'password': _passwordController.text,
        'matches_played': 0,
        'wins': 0,
        'losses': 0,
        'draws': 0,
        'win_percentage': 0.0,
        'goals_for': 0,
        'goals_against': 0,
        'goal_difference': 0,
        'tournament_points': 0,
      };

      bool success = await ApiService.addPlayer(newPlayer);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Player added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add player"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
