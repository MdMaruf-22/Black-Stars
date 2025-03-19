import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //static const String baseUrl = "http://127.0.0.1:8000/api";
  static const String baseUrl = "https://efootball-backend.onrender.com/api";
  // Login API
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    final url = Uri.parse("$baseUrl/players/login/");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Expected response: {"status": "success", "token": "your-token", "message": "Login successful"}
      } else {
        return {
          "status": "failed",
          "message": "Invalid credentials or server error",
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred: $e",
      };
    }
  }

  static Future<List<dynamic>?> getPlayers() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/players/get_all_players/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to fetch players: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return null;
  }

  static Future<bool> addPlayer(Map<String, dynamic> playerData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/players/add/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(playerData),
      );

      if (response.statusCode == 200) {
        print("Player added successfully.");
        return true;
      } else {
        print("Failed to add player: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return false;
  }

  static Future<Map<String, dynamic>?> updatePlayerStats({
    required String clubId,
    required Map<String, dynamic> stats,
    required String month, // Add month parameter
  }) async {
    try {
      // Ensure month format is 'YYYY-MM'
      DateTime parsedMonth;
      try {
        parsedMonth = DateTime.parse("$month-01"); // Temporary to validate 'YYYY-MM'
        month = "${parsedMonth.year}-${parsedMonth.month.toString().padLeft(2, '0')}"; // Formatting
      } catch (e) {
        print("Invalid month format: $month");
        return null;
      }

      // Add month to stats
      stats['month'] = month;

      final response = await http.post(
        Uri.parse('$baseUrl/players/update/$clubId/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(stats),
      );

      if (response.statusCode == 200) {
        print("Player stats updated successfully.");
        return json.decode(response.body);
      } else {
        print("Failed to update player stats: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return null;
  }




  static Future<bool> deletePlayer(String clubId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/players/delete/$clubId/'),
      );

      if (response.statusCode == 200) {
        print("Player deleted successfully.");
        return true;
      } else {
        print("Failed to delete player: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return false;
  }
  static Future<List<dynamic>?> getMonthlyReport(String year, String month) async {
    final url = Uri.parse('$baseUrl/players/monthly_report/$year-$month');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to fetch monthly report: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return null;
  }
  // Fetch individual player data by club ID
  static Future<Map<String, dynamic>?> getPlayerByClubId(String clubId) async {
    final url = Uri.parse('$baseUrl/players/get/$clubId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to fetch player data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return null;
  }
  static Future<bool> resetMonthlyData(String year, String month) async {
    final url = Uri.parse('$baseUrl/players/reset_monthly_data/$year-$month');
    try {
      final response = await http.post(url, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        print("Monthly data reset successfully.");
        return true;
      } else {
        print("Failed to reset monthly data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error connecting to server: $e");
    }
    return false;
  }
  static Future<Map<String, dynamic>?> createNewMonthTable() async {
    final url = Uri.parse('$baseUrl/players/create_new_month_table/');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // If the table is created successfully, return the response data
        final data = jsonDecode(response.body);
        return data;
      } else {
        // If the creation fails (e.g., table already exists), return a failure message
        return {
          "status": "failed",
          "message": "Failed to create new month table: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred: $e",
      };
    }
  }
}
