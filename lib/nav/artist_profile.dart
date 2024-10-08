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

class ArtistProfile extends StatefulWidget {
  const ArtistProfile({Key? key}) : super(key: key);

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  bool isLoading = false;
  bool isMyEventsTab = true;
  List<Event> allEvents = [];
  List<Event> savedEvents = [];
  List<Event> artistEvent = [];
  dynamic follows = {};
  String? currentUser;

  _fetchAllEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    List<String> savedEventIds =
        (prefs.getStringList('savedEventIds') ?? []).toList();

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
      print(res);
      var body = json.decode(res);
      var followerRes = json.decode(resFollows);
      print(body);
      EventList filteredEvents = EventHelper.filterEventsByType(body);
      allEvents = filteredEvents.allEvents;
      follows = followerRes;
      // for (var event in filteredEvents.cultureEvents) {
      //   allEvents.add(event);
      // }
      // for (var event in filteredEvents.gospelEvents) {
      //   allEvents.add(event);
      // }

      for (var event in allEvents) {
        if (savedEventIds.contains(event.id)) {
          savedEvents.add(event);
        }
      }
      print(userAuthProvider.authState.id);
      for (var event in allEvents) {
         for (var artist in event.artists) {
            if (artist['id'] == userAuthProvider.authState.id) {
          artistEvent.add(event);
        }
         }

      }
      print(artistEvent);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Artist Profile"),
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? Center(
              child: AppSmallText(text: "Loading..."),
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
                              image: const DecorationImage(
                                  image: AssetImage('assets/RectangleHome.png'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  AppLargeText(text: '${follows['followers']}'),
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
                                  AppLargeText(text: '${follows['following']}'),
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
                        text: "$currentUser",
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
                        Expanded(
                            child: TextButton(
                          onPressed: () {
                            setState(() {
                              isMyEventsTab = true;
                            });
                          },
                          child: AppSmallText(
                            text: 'My Events',
                            color: isMyEventsTab
                                ? AppColors.accent
                                : AppColors.textColor2,
                          ),
                        )),
                        Expanded(
                            child: TextButton(
                          onPressed: () {
                            setState(() {
                              isMyEventsTab = false;
                            });
                          },
                          child: AppSmallText(
                            text: 'Saved Events',
                            color: isMyEventsTab
                                ? AppColors.textColor2
                                : AppColors.accent,
                          ),
                        )),
                      ],
                    ),
                    isMyEventsTab
                        ? Expanded(child: _buildEventList(artistEvent))
                        : Expanded(child: _buildEventList(savedEvents)),
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
        return InkWell(
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
                      text: "${DateTimeHelper.formatDate(event.dateTime)}-2024",
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
        );
      },
    );
  }
}
