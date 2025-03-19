import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart'; // Assume this contains the API logic

class UpdateMatchDetailsPage extends StatefulWidget {
  @override
  _UpdateMatchDetailsPageState createState() => _UpdateMatchDetailsPageState();
}

class _UpdateMatchDetailsPageState extends State<UpdateMatchDetailsPage> {
  List<dynamic> players = [];
  String? selectedPlayerId;
  String? selectedMonth; // Stored in YYYY-MM format for API
  int goalsFor = 0;
  int goalsAgainst = 0;
  bool motm = false;

  final DateFormat _displayFormat = DateFormat("MMMM yyyy"); // Display format
  final DateFormat _apiFormat = DateFormat("yyyy-MM"); // API format

  List<Map<String, String>> months = [];

  @override
  void initState() {
    super.initState();
    _generateMonths();
    // Find the current month in API format
    String currentMonth = _apiFormat.format(DateTime.now());
    selectedMonth = months.firstWhere(
    (month) => month['value'] == currentMonth,
    orElse: () => months.last, // Fallback if not found
    )['value'];
    fetchPlayers();
    // selectedMonth = months.last['value']; // Default to the current month (API format)
  }

  void _generateMonths() {
    DateTime now = DateTime.now();
    months = List.generate(12, (index) {
      DateTime date = DateTime(now.year, index + 1);
      return {
        "display": _displayFormat.format(date), // "January 2025"
        "value": _apiFormat.format(date), // "2025-01"
      };
    });
  }

  Future<void> fetchPlayers() async {
    var response = await ApiService.getPlayers();
    if (response != null) {
      setState(() {
        players = response;
      });
    }
  }

  Future<void> submitMatchDetails() async {
    if (selectedPlayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a player.")),
      );
      return;
    }

    // Determine result automatically
    String result;
    if (goalsFor > goalsAgainst) {
      result = "win";
    } else if (goalsFor < goalsAgainst) {
      result = "loss";
    } else {
      result = "draw";
    }

    var response = await ApiService.updatePlayerStats(
      clubId: selectedPlayerId!,
      month: selectedMonth!,
      stats: {
        "result": result,
        "goals_for": goalsFor,
        "goals_against": goalsAgainst,
        "motm": motm,
      },
    );

    if (response != null && response['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );

      // Reset fields after successful submission
      setState(() {
        selectedPlayerId = null;
        selectedMonth = months.last['value']; // Reset to current month
        goalsFor = 0;
        goalsAgainst = 0;
        motm = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update match details.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Update Match Details"),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: players.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              "Select Player",
              selectedPlayerId,
              players.map((player) => DropdownMenuItem<String>(
                value: player['club_id'],
                child: Text(player['name']),
              )).toList(),
                  (value) {
                setState(() {
                  selectedPlayerId = value;
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Select Month",
              selectedMonth,
              months.map((month) => DropdownMenuItem<String>(
                value: month['value'],
                child: Text(month['display']!), // Show full month name
              )).toList(),
                  (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
            SizedBox(height: 16),
            _buildScoreDropdown("Goals For", goalsFor, (value) {
              setState(() {
                goalsFor = value!;
              });
            }),
            SizedBox(height: 24),
            _buildScoreDropdown("Goals Against", goalsAgainst, (value) {
              setState(() {
                goalsAgainst = value!;
              });
            }),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  "Man of the Match",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Checkbox(
                  value: motm,
                  onChanged: (value) {
                    setState(() {
                      motm = value ?? false;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: submitMatchDetails,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  child: Text("Submit", style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value,
      List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text("Choose an option"),
            items: items,
            onChanged: onChanged,
            style: TextStyle(color: Colors.black, fontSize: 16),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDropdown(String label, int value, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: List.generate(16, (index) => index)
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
          .toList(),
      onChanged: onChanged,
    );
  }
}

