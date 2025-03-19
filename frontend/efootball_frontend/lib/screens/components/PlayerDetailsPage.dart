import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PlayerDetailsPage extends StatefulWidget {
  const PlayerDetailsPage({Key? key}) : super(key: key);

  @override
  _PlayerDetailsPageState createState() => _PlayerDetailsPageState();
}

class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  String? selectedPlayerId;
  List<dynamic> players = [];
  Map<String, dynamic>? selectedPlayerData;

  Future<void> fetchPlayers() async {
    List<dynamic>? playerList = await ApiService.getPlayers();
    if (playerList != null) {
      setState(() {
        players = playerList;
      });
    }
  }

  Future<void> fetchPlayerData(String clubId) async {
    Map<String, dynamic>? playerData = await ApiService.getPlayerByClubId(clubId);
    setState(() {
      selectedPlayerData = playerData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.purple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Select Player",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedPlayerId,
                    hint: const Text("Select a Player"),
                    isExpanded: true,
                    items: players.map((player) {
                      return DropdownMenuItem<String>(
                        value: player['club_id'].toString(),
                        child: Text(player['name']),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedPlayerId = value;
                      });
                      if (value != null) {
                        fetchPlayerData(value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  if (selectedPlayerData == null)
                    const Center(
                      child: Text(
                        "Select a player to view details",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  if (selectedPlayerData != null) _buildPlayerDetailsCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPlayerDetailsCard() {
    var player = selectedPlayerData!;

    // Calculate Man of the Match (MOTM) as an integer
    int points = int.tryParse(player['tournament_points']?.toString() ?? '0') ?? 0;
    int wins = int.tryParse(player['wins']?.toString() ?? '0') ?? 0;
    int draws = int.tryParse(player['draws']?.toString() ?? '0') ?? 0;
    int motm = ((points - (wins * 3 + draws * 1)) / 2).round(); // Ensure integer

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Slightly wider card
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            Text(
              player['name'] ?? 'N/A',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const Divider(thickness: 1, color: Colors.black12, height: 30),
            // Details Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStyledDetail("Club ID", player['club_id']?.toString() ?? 'N/A', 1),
                _buildStyledDetail("Matches Played", player['matches_played']?.toString() ?? '0', 2),
                _buildStyledDetail("Goals For", player['goals_for']?.toString() ?? '0', 3),
                _buildStyledDetail("Goals Conceded", player['goals_against']?.toString() ?? '0', 4),
                _buildStyledDetail("Goal Difference", player['goal_difference']?.toString() ?? '0', 5),
                _buildStyledDetail("Wins", player['wins']?.toString() ?? '0', 6),
                _buildStyledDetail("Losses", player['losses']?.toString() ?? '0', 7),
                _buildStyledDetail("Draws", player['draws']?.toString() ?? '0', 8),
                _buildStyledDetail("Win Percentage", player['win_percentage']?.toString() ?? '0%', 9),
                _buildStyledDetail("Points", player['tournament_points']?.toString() ?? '0', 10),
              ],
            ),
            const SizedBox(height: 20),
            // MOTM Section
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Man of the Match (MOTM)",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    motm.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildStyledDetail(String label, String value, int index) {
    bool isEven = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isEven ? Colors.blue.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            ":",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
