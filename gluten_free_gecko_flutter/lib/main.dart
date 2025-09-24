import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'restaurants_page.dart';
import 'profile_page.dart';
import 'paywall_page.dart';

void main() {
  runApp(GlutenFreeGeckoApp());
}

class GlutenFreeGeckoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gluten Free Gecko SEA',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color(0xFF4CAF50),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int reputationPoints = 120;
  String userSubscription = 'free';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reputationPoints = prefs.getInt('reputationPoints') ?? 120;
      userSubscription = prefs.getString('geckoSubscription') ?? 'free';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reputationPoints', reputationPoints);
    await prefs.setString('geckoSubscription', userSubscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          RestaurantsPage(),
          ProfilePage(reputationPoints: reputationPoints),
          PaywallPage(
            currentSubscription: userSubscription,
            onSubscriptionChange: (subscription) {
              setState(() {
                userSubscription = subscription;
              });
              _saveUserData();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Text('🍽️', style: TextStyle(fontSize: 20)),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Text('👤', style: TextStyle(fontSize: 20)),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Text('⭐', style: TextStyle(fontSize: 20)),
            label: 'Unlimited',
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
      ),
      child: Column(
        children: [
          // Status Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TimeOfDay.now().format(context),
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 19,
                            height: 10,
                            margin: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Color(0xFF4ade80),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          Positioned(
                            right: -3,
                            top: 3,
                            child: Container(
                              width: 2,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(1),
                                  bottomRight: Radius.circular(1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.transparent, Colors.white, Colors.transparent, Colors.white],
                          stops: [0.0, 0.25, 0.3, 0.75, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // App Header
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              '🦎 Gluten Free Gecko SEA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120);
}