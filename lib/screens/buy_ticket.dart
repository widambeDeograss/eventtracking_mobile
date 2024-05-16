import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/event_filter.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BuyTicketScreen extends StatefulWidget {
  final Event? event;
  const BuyTicketScreen({Key? key, this.event}) : super(key: key);

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  int ticketsAmount = 1;
  bool isLoading = false;

  int totalTicketPrice() {
    int totalPrice = ticketsAmount * widget.event!.price;

    return totalPrice;
  }

  _buyTicket() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    var data = {
      "user": userAuthProvider.authState.id,
      "event": widget.event!.id,
      "number": ticketsAmount,
      "amount": totalTicketPrice()
    };

    print(data);
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi().authenticatedRequest(
          data, AppConstants.apiBaseUrl + AppConstants.tickets, 'post');
      print(res);
      var body = json.decode(res);

      if (body['save']) {
        print("object=========================");
        Fluttertoast.showToast(
            msg: "Ticket bought Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LoginScreen(),
        //   ),
        // );
      } else {
        await Fluttertoast.showToast(
            msg: "Buying ticket failed, out of tickets try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error: buying tickets failed try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.event!.name} Tickets"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.68,
            width: double.maxFinite,
            padding: const EdgeInsets.all(10),
            // width: MediaQuery.of(context).size.width - 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLargeText(
                    text: "${widget.event!.name}",
                    size: 25,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppLargeText(
                    text: "Price per Ticket:",
                    size: 23,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppLargeText(
                    text: "Tzs ${widget.event!.price}/=",
                    size: 20,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => {
                          if (ticketsAmount > 1)
                            {
                              setState(() {
                                ticketsAmount--;
                              })
                            }
                          else
                            {}
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            // height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Icon(Icons.minimize))),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          // height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.textColor2,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "$ticketsAmount",
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () => {
                          setState(() {
                            ticketsAmount++;
                          })
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.add)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    // height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.addsOn,
                        borderRadius: BorderRadius.circular(10)),
                    child: AppLargeText(
                      text: "Tzs ${totalTicketPrice()}",
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: AppColors.addsOn,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppColors.primary,
                              title: const Text('Buy tickets'),
                              content: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Are you sure you want to buy this ticket?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Perform logout actions here
                                    _buyTicket();
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Buy'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Buy Ticket",
                        style: TextStyle(
                          color: AppColors.textColor1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
