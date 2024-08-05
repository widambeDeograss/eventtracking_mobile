import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/screens/payment.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:flutter/material.dart';

import '../helper/event_filter.dart';

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
    return ticketsAmount * widget.event!.price;
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
                        onTap: () {
                          if (ticketsAmount > 1) {
                            setState(() {
                              ticketsAmount--;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.remove)),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.textColor2,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "$ticketsAmount",
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            ticketsAmount++;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
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
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Prepare the dataBuy map
                                    var dataBuy = {
                                      "event": widget.event!.id,
                                      "number": ticketsAmount,
                                      "amount": totalTicketPrice()
                                    };

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FlutterwavePayment(paymentData: dataBuy),
                                      ),
                                    );
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
