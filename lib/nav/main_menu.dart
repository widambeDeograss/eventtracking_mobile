import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/nav/artist_profile.dart';
import 'package:eventtracking/nav/events.dart';
import 'package:eventtracking/nav/home.dart';
import 'package:eventtracking/nav/profile.dart';
import 'package:eventtracking/nav/tickets.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List pages = [HomePage(), ScanPage(), ProfilePage()];

  List<Widget> pages = [
    const HomeScreen(),
    const EventsScreen(),
    const TicketsScreen(),
    const ProfileScreen()
  ]; // Initialize as empty list

  @override
  void initState() {
    super.initState();
    _updatePages(); // Call method to update pages list
  }

  void _updatePages() {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    final userType = userAuthProvider.authState.isArtist;
    print(userAuthProvider.authState);
    // Conditionally set pages list based on user type
    setState(() {
      if (userType == 'artist') {
        pages = [
          const HomeScreen(),
          const EventsScreen(),
          const TicketsScreen(),
          const ArtistProfile()
        ];
      } else {
        pages = [
          const HomeScreen(),
          const EventsScreen(),
          const TicketsScreen(),
          const ProfileScreen()
        ];
      }
    });
  }

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: pages[currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: AppColors.accent,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              currentIndex: currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.withOpacity(0.5),
              // backgroundColor: AppColors.accent,

              // showSelectedLabels: false,
              // showUnselectedLabels: false,
              onTap: onTap,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.speaker_group_outlined), label: "Events"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.card_membership), label: "Tickets"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
