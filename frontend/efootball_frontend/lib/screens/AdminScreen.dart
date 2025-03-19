import 'package:flutter/material.dart';
import 'admin_pages/CreateMonthTablePage.dart';
import 'admin_pages/add_player_page.dart';
import 'admin_pages/delete_player_page.dart';
import 'admin_pages/update_match_details_page.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String selectedMenu = "Add Player";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: AppBar(
            title: Text("Admin Dashboard"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous page
              },
            ),
            actions: isDesktop
                ? []
                : [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    selectedMenu = value;
                  });
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: "Add Player",
                    child: Text("Add Player"),
                  ),
                  PopupMenuItem(
                    value: "Delete Player",
                    child: Text("Delete Player"),
                  ),
                  PopupMenuItem(
                    value: "Update Match Details",
                    child: Text("Update Match Details"),
                  ),
                  PopupMenuItem(
                    value: "Create New Month Table",  // New option
                    child: Text("Create New Month Table"),
                  ),
                ],
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(), // Sidebar for larger screens
              Expanded(
                child: _renderMainContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.blueGrey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Admin Dashboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(color: Colors.white54),
          _buildMenuButton("Add Player"),
          _buildMenuButton("Delete Player"),
          _buildMenuButton("Update Match Details"),
          _buildMenuButton("Create New Month Table"), // New menu item
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
      },
      child: Container(
        width: double.infinity,
        color: selectedMenu == title ? Colors.blueGrey[600] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _renderMainContent() {
    switch (selectedMenu) {
      case "Add Player":
        return AddPlayerPage();
      case "Delete Player":
        return DeletePlayerPage();
      case "Update Match Details":
        return UpdateMatchDetailsPage();
      case "Create New Month Table":
        return CreateMonthTablePage();  // Show the new page
      default:
        return Center(
          child: Text(
            "Select an option from the menu",
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }
}
