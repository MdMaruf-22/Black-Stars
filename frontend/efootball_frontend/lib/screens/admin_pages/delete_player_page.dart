import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DeletePlayerPage extends StatefulWidget {
  @override
  _DeletePlayerPageState createState() => _DeletePlayerPageState();
}

class _DeletePlayerPageState extends State<DeletePlayerPage> {
  List<dynamic> players = [];
  String? selectedPlayerId;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    var response = await ApiService.getPlayers();
    if (response != null) {
      setState(() {
        players = response;
      });
    }
  }

  Future<void> deletePlayer() async {
    if (selectedPlayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a player to delete.")),
      );
      return;
    }

    bool success = await ApiService.deletePlayer(selectedPlayerId!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Player deleted successfully.")),
      );
      fetchPlayers(); // Refresh the list of players
      setState(() {
        selectedPlayerId = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete player.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen width is smaller than 600 (mobile view)
        bool isMobile = constraints.maxWidth < 600;
        double padding = isMobile ? 16.0 : 32.0;
        double textSize = isMobile ? 16.0 : 18.0;
        double buttonPadding = isMobile ? 12.0 : 16.0;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Delete Player"),
            backgroundColor: Colors.redAccent,
          ),
          body: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a player to delete:",
                  style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                players.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  value: selectedPlayerId,
                  hint: Text("Select a player"),
                  items: players.map((player) {
                    return DropdownMenuItem<String>(
                      value: player['club_id'],
                      child: Text(player['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlayerId = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: deletePlayer,
                  child: Text("Delete Player"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonPadding, horizontal: 20),
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
