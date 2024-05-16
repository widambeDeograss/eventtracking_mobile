import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/screens/event_description.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  TextEditingController queryController = TextEditingController();
  bool isLoading = false;
  List<Event> allEvents = [];

  _fetchAllEvents() async {
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
      allEvents = filteredEvents.bongoFlevaEvents;
      for (var event in filteredEvents.cultureEvents) {
        allEvents.add(event);
      }
      for (var event in filteredEvents.gospelEvents) {
        allEvents.add(event);
      }
      print(allEvents);
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
        title: Text("Events"),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
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
              Expanded(child: _buildEventList(allEvents))
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
