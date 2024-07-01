import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/event_description.dart';
import 'package:eventtracking/screens/update_profile.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  List<Event> allEvents = [];
  List<Event> savedEvents = [];
  dynamic follows = {};
  String? currentUser;
  bool isFollowing = false;
  dynamic profile;

  _fetchAllEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEventIds =
        (prefs.getStringList('savedEventIds') ?? []).toList();
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
      var resFollows = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.followers}?querytype=single&&userId${userAuthProvider.authState.id}",
          'get');
      var userRes = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allUsers}?querytype=single&&user_id${userAuthProvider.authState.id}",
          'get');
      print(res);
      var body = json.decode(res);
      var userBody = json.decode(userRes);
      profile  = userBody['profile'];
      var followerRes = json.decode(resFollows);
      follows = followerRes;
      EventList filteredEvents = EventHelper.filterEventsByType(body);
      allEvents = filteredEvents.bongoFlevaEvents;
      for (var event in filteredEvents.cultureEvents) {
        allEvents.add(event);
      }
      for (var event in filteredEvents.gospelEvents) {
        allEvents.add(event);
      }
      print("=======================");
      print(savedEvents);
      for (var event in allEvents) {
        if (savedEventIds.contains(event.id)) {
          savedEvents.add(event);
        }
      }
      print("=======================");
      print(savedEvents);
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

  _postFollower() async {
    try {
      setState(() {
        isFollowing = true;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? Center(
              child: AppSmallText(
                text: "Loading...",
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            // width: MediaQuery.of(context).size.width - 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image:  DecorationImage(
                                  image:profile == null ? const NetworkImage("https://www.freepik.com/free-vector/user-circles-set_145856997.htm#query=user%20profile&position=13&from_view=keyword&track=ais_user&uuid=dea66171-42e7-4348-9de3-563e306d5f13"):  NetworkImage("${AppConstants.mediaBaseUrl}/${profile}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  AppLargeText(text: "${follows['followers']}"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppSmallText(text: "followers"),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              SizedBox(
                                height: 70,
                                width: 1,
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  AppLargeText(text: "${follows['following']}"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppSmallText(text: "following"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: AppLargeText(
                        text: "${currentUser}",
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: AppColors.addsOn,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(
                                //       10), // Set border radius here
                                // ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const UpdateProfileScreen()));
                              },
                              child: const Text(
                                "Edit profile",
                                style: TextStyle(
                                    color: AppColors.textColor1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: AppColors.addsOn,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(
                                //       10), // Set border radius here
                                // ),
                              ),
                              onPressed: () {
                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(builder: (_) => const LoginScreen()));
                              },
                              child: const Text(
                                "Share Profile",
                                style: TextStyle(
                                    color: AppColors.textColor1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        // Expanded(
                        //     child: TextButton(
                        //   onPressed: () {},
                        //   child: AppSmallText(
                        //     text: 'My Events',
                        //     color: AppColors.accent,
                        //   ),
                        // )),
                        Expanded(
                            child: TextButton(
                          onPressed: () {},
                          child: AppSmallText(
                            text: 'Saved Events',
                          ),
                        )),
                      ],
                    ),
                    Expanded(child: _buildEventList(savedEvents)),
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
                height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accent),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      // width: MediaQuery.of(context).size.width - 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                "${AppConstants.mediaBaseUrl}${event.profile}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        AppLargeText(
                          text:
                              "${DateTimeHelper.formatDate(event.dateTime)}-2024",
                          size: 16,
                        ),
                        AppSmallText(
                          text:
                              "${DateTimeHelper.formatWeekday(event.dateTime)}-${DateTimeHelper.formatTime(event.dateTime)} PM",
                          size: 12,
                        ),
                        AppLargeText(
                          text: "${event.name}",
                          size: 14,
                        ),
                        AppSmallText(
                          text: "${event.location}",
                          size: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
