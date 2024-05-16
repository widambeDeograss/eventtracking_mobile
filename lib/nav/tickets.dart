import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/tickets_helper.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/ticket_description.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<Ticket> inActive = [];
  List<Ticket> active = [];
  bool isLoading = false;

  _fetchAllEvents() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });
      var res = await CallApi().authenticatedRequest({},
          "${AppConstants.apiBaseUrl}${AppConstants.tickets}?querytype=single&&userId=${userAuthProvider.authState.id}",
          'get');
      print(res);
      var body = json.decode(res);
      print(body);
      TicketList filteredTickets = TicketsHelper.filterEventsByType(body);

      print("BongoFleva Events:");
      active = filteredTickets.activeTickets;
      inActive = filteredTickets.inActiveTickets;
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
          msg: "Error: Failing to get Tickets check your internet",
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Text("Tickets"),
          backgroundColor: AppColors.primary,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  child: const TabBar(tabs: [
                    Tab(text: "Active"),
                    Tab(text: "Inactive"),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: TabBarView(
                    children: [
                      _buildEventList(active),
                      _buildEventList(inActive)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Ticket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Column(
          children: [
            InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketDescription(
                            ticket: ticket,
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
                        image: const DecorationImage(
                            image: AssetImage('assets/qr.png'),
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
                          text: "${ticket.event["name"]}",
                          size: 16,
                        ),
                        AppSmallText(
                          text:
                              "${ticket.createdAt.year}-${ticket.createdAt.month}-${ticket.createdAt.day}",
                          size: 12,
                        ),
                        AppLargeText(
                          text: "${ticket.amount} Tzs",
                          size: 14,
                        ),
                        AppSmallText(
                          text: "${ticket.number}",
                          size: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
