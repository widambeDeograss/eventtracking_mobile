import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/helper/followers_helper.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/event_description.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewArtistProfile extends StatefulWidget {
  final String? artistId;
  const ViewArtistProfile({Key? key, this.artistId}) : super(key: key);

  @override
  State<ViewArtistProfile> createState() => _ViewArtistProfileState();
}

class _ViewArtistProfileState extends State<ViewArtistProfile> {
  bool isLoading = false;
  bool isMyEventsTab = true;
  bool isArtistFollowed = false;
  List<Event> allEvents = [];
  List<Event> savedEvents = [];
  List<Event> artistEvent = [];
  dynamic artistInfo = {};
  dynamic artistFollows = [];
  dynamic follows = {};

  String? currentUser;

  _fetchAllEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);

    currentUser = userAuthProvider.authState.id;
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allEvents}?querytype=all",
          'get');
      var resArtistInfo = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allUsers}?querytype=single&&user_id=${widget.artistId}",
          'get');

      var resFollows = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.followers}?querytype=single&&userId=${widget.artistId}",
          'get');
      var resAllFollows = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.followers}?querytype=all",
          'get');

      var followerRes = json.decode(resAllFollows);

      var followerArtRes = json.decode(resFollows);
      var body = json.decode(res);
      var artistInfoRes = json.decode(resArtistInfo);
      EventList filteredEvents = EventHelper.filterEventsByType(body);
      FollowList fllws = FollowHelper.filterEventsByType(followerRes);

      allEvents = filteredEvents.allEvents;
      artistInfo = artistInfoRes;
      artistFollows = followerRes;
      follows = followerArtRes;

      // for (var event in filteredEvents.cultureEvents) {
      //   allEvents.add(event);
      // }
      // for (var event in filteredEvents.gospelEvents) {
      //   allEvents.add(event);
      // }
      for (var event in allEvents) {
        if (event.artist['id'] == widget.artistId) {
          artistEvent.add(event);
        }
      }

      print(fllws.followList);
      for (var foll in fllws.followList) {
        print(foll.follower);
        if (foll.follower['id'] == userAuthProvider.authState.id &&
            foll.artist['id'] == widget.artistId) {
          isArtistFollowed = true;
        }
      }
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

  _postFollow() async {}

  _postUnFollow() async {}

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Artist Profile"),
          backgroundColor: AppColors.primary,
        ),
        backgroundColor: AppColors.primary,
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
                              border: Border.all(
                                  width: 1, color: AppColors.textColor1),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${AppConstants.mediaBaseUrl}/${artistInfo['profile']}"),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: AppLargeText(
                              text: "${artistInfo['username']}",
                              size: 24,
                            ),
                          ),
                        ),
                        isArtistFollowed
                            ? Expanded(
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
                                    _postUnFollow();
                                  },
                                  child: const Text(
                                    "Unfollow",
                                    style: TextStyle(
                                        color: AppColors.textColor1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : Expanded(
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
                                    _postFollow();
                                  },
                                  child: const Text(
                                    "Follow",
                                    style: TextStyle(
                                        color: AppColors.textColor1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ],
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
                            text: 'Events',
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
                            text: 'Biography',
                            color: isMyEventsTab
                                ? AppColors.textColor2
                                : AppColors.accent,
                          ),
                        )),
                      ],
                    ),
                    isMyEventsTab
                        ? Expanded(child: _buildEventList(artistEvent))
                        : Expanded(
                            child: Column(
                            children: [
                              Container(
                                height: 280,
                                // width: 150,
                                padding: const EdgeInsets.all(10),
                                // width: MediaQuery.of(context).size.width - 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${AppConstants.mediaBaseUrl}/${artistInfo['profile']}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: artistInfo['biography'] == null
                                    ? AppSmallText(
                                        text: "This artist has no biography")
                                    : AppLargeText(
                                        text: "${artistInfo['biography']}",
                                        size: 15,
                                      ),
                              ))
                            ],
                          )),
                  ],
                ),
              )));
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
