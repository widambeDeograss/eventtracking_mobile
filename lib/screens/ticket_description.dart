import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/helper/datetime_helper.dart';
import 'package:eventtracking/helper/tickets_helper.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDescription extends StatefulWidget {
  final Ticket? ticket;
  const TicketDescription({Key? key, this.ticket}) : super(key: key);

  @override
  State<TicketDescription> createState() => _TicketDescriptionState();
}

class _TicketDescriptionState extends State<TicketDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.78,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => {}, icon: const Icon(Icons.download)),
                  ),
                  AppSmallText(text: "Event Name:"),
                  AppLargeText(text: "${widget.ticket!.event['name']}"),
                  const SizedBox(height: 20),
                  AppSmallText(text: "Event Date:"),
                  AppLargeText(
                    text:
                        "${DateTimeHelper.formatDate(widget.ticket!.event['date_time'])}-2024",
                    size: 16,
                  ),
                  AppSmallText(
                      text:
                          "${DateTimeHelper.formatWeekday(widget.ticket!.event['date_time'])}-${DateTimeHelper.formatTime(widget.ticket!.event['date_time'] as String)} PM"),
                  const SizedBox(height: 10),
                  AppSmallText(text: "Ticket number:"),
                  AppLargeText(text: widget.ticket!.id.substring(0, 5)),
                  const SizedBox(height: 10),
                  AppSmallText(text: "Total Seats:"),
                  AppSmallText(text: "${widget.ticket!.number}"),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: widget.ticket!.id,
                    version: QrVersions.auto,
                    size: 200.0,
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
