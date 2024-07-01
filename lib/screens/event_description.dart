import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/screens/buy_ticket.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:eventtracking/widgets/comments_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDescription extends StatefulWidget {
  final Event? event;
  const EventDescription({Key? key, this.event}) : super(key: key);

  @override
  State<EventDescription> createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventDescription> {
  dynamic? currentEvent;
  bool isLoading = false;
  bool isSaved = false;

  _fetchAllEvents() async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.allEvents}?querytype=single&&eventId=${widget.event!.id}",
          'get');
      print(res);
      var body = json.decode(res);
      print(body);
      currentEvent = body;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error: Failing to get event check ypur internet",
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

  Future<void> _toggleSaveEvent(BuildContext context, String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEventIds =
        (prefs.getStringList('savedEventIds') ?? []).toList();

    if (savedEventIds.contains(eventId)) {
      savedEventIds.remove(eventId);
      await _checkEventSaved(context, eventId);
    } else {
      savedEventIds.add(eventId);
      await _checkEventSaved(context, eventId);
    }

    await prefs.setStringList('savedEventIds', savedEventIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(savedEventIds.contains(eventId)
          ? 'Event saved'
          : 'Event removed from saved'),
    ));
  }

  Future<void> _checkEventSaved(BuildContext context, String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEventIds =
        (prefs.getStringList('savedEventIds') ?? []).toList();

    if (savedEventIds.contains(eventId)) {
      isSaved = true;
    } else {
      isSaved = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
    _checkEventSaved(context, widget.event!.id);
  }

  void _openCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(eventId: widget.event!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event!.name),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280,
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                // width: MediaQuery.of(context).size.width - 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(
                          "${AppConstants.mediaBaseUrl} ${widget.event!.profile}"),
                      fit: BoxFit.fill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => {},
                                icon: const Icon(Icons.favorite_border)),
                            IconButton(
                                onPressed: () => {
                                      _openCommentDialog(context),
                                    },
                                icon: const Icon(Icons.comment)),
                            IconButton(
                                onPressed: () => {},
                                icon: const Icon(Icons.share)),
                          ],
                        ),
                        IconButton(
                            onPressed: () =>
                                {_toggleSaveEvent(context, widget.event!.id)},
                            icon: Icon(
                              isSaved
                                  ? Icons.bookmark_added
                                  : Icons.bookmark_add_outlined,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppLargeText(text: widget.event!.name),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.calendar_month_outlined)),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text:
                                  "${DateTimeHelper.formatDate(widget.event!.dateTime as String)}-2024",
                              size: 16,
                            ),
                            AppSmallText(
                                text:
                                    "${DateTimeHelper.formatWeekday(widget.event!.dateTime as String)}-${DateTimeHelper.formatTime(widget.event!.dateTime as String)} PM")
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.location_on)),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              text: widget.event!.location,
                              size: 16,
                            ),
                            // AppSmallText(text: "Kitope Road, Morogoro")
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OverlappingAvatarRow(artists: widget.event!.artists),
                    const SizedBox(
                      height: 15,
                    ),
                    AppLargeText(
                      text: "Description",
                      size: 17,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.event!.description}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.textColor1,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
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
                          if (widget.event!.ticketsAmount == 0) {
                            Fluttertoast.showToast(
                                msg:
                                    "Sorry!:  there are no more tickets for this event",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.orangeAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            return;
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BuyTicketScreen(
                                          event: widget.event,
                                        )));
                          }
                        },
                        child: const Text(
                          "Get Ticket",
                          style: TextStyle(
                              color: AppColors.textColor1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlappingAvatarRow extends StatelessWidget {
  final List<dynamic> artists;

  OverlappingAvatarRow({required this.artists});

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: artists.asMap().entries.map((entry) {
        int idx = entry.key;
        dynamic artist = entry.value;
        String? profile = artist['profile'];

        return Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                radius: 15,
                backgroundImage: profile != null
                    ? NetworkImage('${AppConstants.mediaBaseUrl}$profile')
                    : null,
                child: profile == null ? Icon(Icons.person, size: 10) : null,
              ),
              const SizedBox(
                width: 10,
              ),
              AppLargeText(
                text: artist["username"],
                size: 14,
              ),
                ],
              ),
              ElevatedButton(
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
                            "Follow",
                            style: TextStyle(
                                color: AppColors.textColor1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
              
            ]);
      }).toList(),
    );
  }
}
