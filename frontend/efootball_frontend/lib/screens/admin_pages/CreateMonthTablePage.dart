import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/api_service.dart';


class CreateMonthTablePage extends StatefulWidget {
  @override
  _CreateMonthTablePageState createState() => _CreateMonthTablePageState();
}

class _CreateMonthTablePageState extends State<CreateMonthTablePage> {
  late String currentMonth;
  late String currentYear;

  @override
  void initState() {
    super.initState();
    // Get the current year and month
    final DateTime now = DateTime.now();
    currentYear = now.year.toString();
    currentMonth = DateFormat('MMMM').format(now); // e.g., "December"
  }

  // Method to handle the creation of the table
  Future<void> _createNewMonthTable() async {
    var result = await ApiService.createNewMonthTable();
    if (result != null && result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New month table created successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create new month table")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create New Month Table",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Year: $currentYear",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "Month: $currentMonth",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _createNewMonthTable,
            child: Text("Create Table"),
          ),
        ],
      ),
    );
  }
}
