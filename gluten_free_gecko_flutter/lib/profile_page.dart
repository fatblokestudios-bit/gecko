import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final int reputationPoints;

  const ProfilePage({Key? key, required this.reputationPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelProgress = (reputationPoints % 200) / 200;
    
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 40),
          // Profile Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                '🦎',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
          SizedBox(height: 24),
          // Profile Name
          Text(
            'FatBloke from New Zealand',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          // Reputation Points
          Text(
            'Reputation: $reputationPoints points',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          // Level Progress
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: levelProgress,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Level Progress',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Additional profile information could go here
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Keep discovering great gluten-free restaurants to earn more reputation points!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}