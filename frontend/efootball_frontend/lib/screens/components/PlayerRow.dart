import 'package:flutter/material.dart';

class PlayerTable extends StatelessWidget {
  final Size size;
  final List<dynamic> players;

  const PlayerTable({required this.size, required this.players});

  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedPlayers = List.from(players)
      ..sort((a, b) {
        int pointComparison = b['tournament_points'].compareTo(a['tournament_points']);
        if (pointComparison != 0) return pointComparison;

        int gdComparison = b['goal_difference'].compareTo(a['goal_difference']);
        if (gdComparison != 0) return gdComparison;

        return b['goals_for'].compareTo(a['goals_for']);
      });

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitle(),
          SizedBox(height: 20),
          _buildTableHeader(),
          ...sortedPlayers.map((player) => _buildPlayerRow(player)).toList(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.indigoAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Player Ranking",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black38,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHeaderCell("Name"),
            _buildHeaderCell("ID"),
            _buildHeaderCell("MP"),
            _buildHeaderCell("W"),
            _buildHeaderCell("L"),
            _buildHeaderCell("D"),
            _buildHeaderCell("GF"),
            _buildHeaderCell("GA"),
            _buildHeaderCell("GD"),
            _buildHeaderCell("W%"),
            _buildHeaderCell("PT"),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlayerRow(dynamic player) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDataCell(player['name'] ?? 'Unknown', multiline: true),
          _buildDataCell(player['club_id'] ?? 'N/A', multiline: true),
          _buildDataCell(player['matches_played'].toString()),
          _buildDataCell(player['wins'].toString()),
          _buildDataCell(player['losses'].toString()),
          _buildDataCell(player['draws'].toString()),
          _buildDataCell(player['goals_for'].toString()),
          _buildDataCell(player['goals_against'].toString()),
          _buildDataCell(player['goal_difference'].toString()),
          _buildDataCell(_formatWinPercentage(player['win_percentage'])),
          _buildDataCell(player['tournament_points'].toString()),
        ],
      ),
    );
  }

  Widget _buildDataCell(String content, {bool multiline = false}) {
    return Expanded(
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          overflow: multiline ? TextOverflow.visible : TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          maxLines: multiline ? null : 1,
          softWrap: multiline,
        ),
      ),
    );
  }

  String _formatWinPercentage(dynamic winPercentage) {
    if (winPercentage is num) {
      if (winPercentage == winPercentage.toInt()) {
        return winPercentage.toInt().toString() + '%';
      } else {
        return winPercentage.toStringAsFixed(2) + '%';
      }
    }
    return "0%";
  }
}
