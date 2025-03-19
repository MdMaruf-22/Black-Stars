import 'package:flutter/material.dart';
import 'components/AdminButton.dart';
import 'components/ClubHeader.dart';
import 'components/PlayerRow.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> players = [];

  @override
  void initState() {
    super.initState();
    fetchPlayers(); // Fetch players when the widget is initialized
  }

  Future<void> fetchPlayers() async {
    var response = await ApiService.getPlayers();
    if (response != null) {
      setState(() {
        players = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "BLACK STARS",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => showAdminLoginDialog(context),
            icon: Icon(Icons.login_rounded, color: Colors.white),
            label: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
      ),
      body: players.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            ClubHeader(size: size), // Updated Club Header
            SizedBox(height: 20),
            PlayerTable(size: size, players: players), // Updated Table
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
