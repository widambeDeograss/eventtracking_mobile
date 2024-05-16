import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/artists.dart';
import 'package:eventtracking/screens/event_description.dart';
import 'package:eventtracking/screens/notifications.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:eventtracking/widgets/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController queryController = TextEditingController();
  List<Event> bongoFlevaEvents = [];
  List<Event> gospelEvents = [];
  List<Event> cultureEvents = [];
  bool isLoading = false;
  String? currentUser;

  _fetchAllEvents() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    currentUser = userAuthProvider.authState.username;
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allEvents}?querytype=all",
          'get');
      print(res);
      var body = json.decode(res);
      print(body);
      EventList filteredEvents = EventHelper.filterEventsByType(body);

      print("BongoFleva Events:");
      bongoFlevaEvents = filteredEvents.bongoFlevaEvents;
      gospelEvents = filteredEvents.gospelEvents;
      cultureEvents = filteredEvents.cultureEvents;
      // print(filteredEvents.bongoFlevaEvents.single);
      // for (var event in filteredEvents.bongoFlevaEvents) {
      //   print(event.name);
      // }
      //
      // print("\nGospel Events:");
      // for (var event in filteredEvents.gospelEvents) {
      //   print(event.name);
      // }
      //
      // print("\nCulture Events:");
      // for (var event in filteredEvents.cultureEvents) {
      //   print(event.name);
      // }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error: Failing to get events check ypur internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtistsScreen(),
            ),
          );
        case 2:
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const LogoutDialog();
              });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: Builder(
              builder: (BuildContext context) => IconButton(
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                  icon: const Icon(Icons.menu))),
          title: Text(""),
          actions: [
            IconButton(
                icon: const Icon(Icons.notification_important),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()),
                  );
                }),
          ],
          // : IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
        ),
        backgroundColor: AppColors.primary,
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.36,
                      child: SearchBar(
                        controller: queryController,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {},
                        onChanged: (_) {},
                        leading: const Icon(Icons.search),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.filter_list_outlined),
                        onPressed: () {}),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const TabBar(tabs: [
                    Tab(text: "BongoFleva"),
                    Tab(text: "Gospel"),
                    Tab(text: "Culture"),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildEventList(bongoFlevaEvents),
                      _buildEventList(gospelEvents),
                      _buildEventList(cultureEvents)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        drawer: Drawer(
          backgroundColor: AppColors.primary,
          elevation: 0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/homeimg.png",
                        height: 60,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          InkWell(
                              onTap: () {},
                              child: Text(
                                currentUser!,
                                style: const TextStyle(
                                    color: AppColors.textColor1,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    // decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.home,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Home',
                        style: TextStyle(color: AppColors.textColor1),
                      ),
                    ),
                  ],
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.supervised_user_circle,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Artists',
                        style: TextStyle(color: AppColors.textColor1),
                      ),
                    ),
                  ],
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtistsScreen(),
                    ),
                  );
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.logout_outlined,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Logout',
                        style: TextStyle(color: AppColors.textColor1),
                      ),
                    ),
                  ],
                ),
                selected: _selectedIndex == 1,
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LogoutDialog();
                      });
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Column(
          children: [
            InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventDescription(
                            event: event,
                          )),
                ),
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 320,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      padding: const EdgeInsets.all(10),
                      // width: MediaQuery.of(context).size.width - 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                "${AppConstants.mediaBaseUrl}${event.profile}"),
                            fit: BoxFit.cover),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: AppSmallText(
                                    text:
                                        "${DateTimeHelper.formatDate(event.dateTime)}",
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                Icons.bookmark_add_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppLargeText(
                      text: event.name,
                      size: 20,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(
                                "${AppConstants.mediaBaseUrl}${event.profile}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        AppSmallText(text: event.location)
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }

  Widget _LoadingSkeletonBuilder() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
