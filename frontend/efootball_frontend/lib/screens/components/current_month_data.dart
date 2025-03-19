import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class MonthlyDataPage extends StatefulWidget {
  const MonthlyDataPage({Key? key}) : super(key: key);

  @override
  State<MonthlyDataPage> createState() => _MonthlyDataPageState();
}

class _MonthlyDataPageState extends State<MonthlyDataPage> {
  String? selectedMonth;
  String year = DateTime.now().year.toString();
  Future<List<dynamic>?>? futureData;

  late final List<String> months;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final int currentMonthIndex = now.month;
    final int previousMonthIndex = (currentMonthIndex == 1) ? 12 : currentMonthIndex - 1;
    final int previousYear = (currentMonthIndex == 1) ? now.year - 1 : now.year;

    months = [
      '${previousYear}-${previousMonthIndex.toString().padLeft(2, '0')}',
      '${now.year}-${currentMonthIndex.toString().padLeft(2, '0')}',
    ];

    selectedMonth = months.last;
    futureData = ApiService.getMonthlyReport(year, selectedMonth!.split('-')[1]);
  }

  void _onMonthSelected(String month) {
    setState(() {
      selectedMonth = month;
      year = month.split('-')[0];
      futureData = ApiService.getMonthlyReport(year, selectedMonth!.split('-')[1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Monthly Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Dropdown to select month
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: selectedMonth,
              items: months.map((month) {
                final monthName = DateTime.parse('$month-01').month.toString();
                return DropdownMenuItem(
                  value: month,
                  child: Text(_monthNameFromIndex(int.parse(month.split('-')[1]))),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _onMonthSelected(value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Select Month',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Data Table Section
          Expanded(
            child: FutureBuilder<List<dynamic>?>(
              future: futureData, // Use named argument
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                } else {
                  return MonthlyDataTable(size: size, data: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _monthNameFromIndex(int index) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[index - 1];
  }
}

class MonthlyDataTable extends StatelessWidget {
  final Size size;
  final List<dynamic> data;

  const MonthlyDataTable({required this.size, required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedData = List.from(data)
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
          const SizedBox(height: 20),
          _buildTableHeader(),
          ...sortedData.map((entry) => _buildDataRow(entry)).toList(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Monthly Data Ranking",
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
        color: Colors.teal,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: const [
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
          style: const TextStyle(
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

  Widget _buildDataRow(dynamic entry) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
          _buildDataCell(entry['name'] ?? 'Unknown', multiline: true),
          _buildDataCell(entry['club_id'] ?? 'N/A', multiline: true),
          _buildDataCell(entry['matches_played'].toString()),
          _buildDataCell(entry['wins'].toString()),
          _buildDataCell(entry['losses'].toString()),
          _buildDataCell(entry['draws'].toString()),
          _buildDataCell(entry['goals_for'].toString()),
          _buildDataCell(entry['goals_against'].toString()),
          _buildDataCell(entry['goal_difference'].toString()),
          _buildDataCell(_formatWinPercentage(entry['win_percentage'])),
          _buildDataCell(entry['tournament_points'].toString()),
        ],
      ),
    );
  }

  Widget _buildDataCell(String content, {bool multiline = false}) {
    return Expanded(
      child: Center(
        child: Text(
          content,
          style: const TextStyle(
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
        return '${winPercentage.toInt()}%';
      } else {
        return '${winPercentage.toStringAsFixed(2)}%';
      }
    }
    return "0%";
  }
}
