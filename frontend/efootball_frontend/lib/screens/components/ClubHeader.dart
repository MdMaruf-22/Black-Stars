import 'package:flutter/material.dart';
import 'PlayerDetailsPage.dart';
import 'current_month_data.dart'; // Import the new screen for current month data

class ClubHeader extends StatelessWidget {
  final Size size;

  const ClubHeader({required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Club Banner
        Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 3,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Club Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with the correct path to your logo image
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(width: 8),
                  const Text(
                    "Black Stars",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              const Text(
                "Work Together, Dream Together",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 6),
              const Text(
                "eFootball",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Get Monthly Data Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthlyDataPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Get Monthly Data",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // Get Individual Data Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Get Individual Data",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        // History Section
        Container(
          width: size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
                    "Black Stars History",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "The Journey of Black Stars began in 2020 as we established the club to compete in tournaments organized by communities nationwide. "
                    "We started with 15 members and have grown into a family of 42 dedicated players. "
                    "Our team proudly participates in competitions organized by communities like COBEG, EFCOB, EAOB, eFOB, and EFFB, among others. "
                    "Together, we strive for excellence and aim to make our mark in the world of eFootball.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
