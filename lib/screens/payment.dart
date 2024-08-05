// ignore_for_file: unnecessary_this, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:eventtracking/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutterwave_standard/flutterwave.dart';

import '../api/api.dart';
import '../constants/app_constants.dart';
import '../nav/tickets.dart';
import '../providers/user_management_provider.dart';
import 'buy_ticket.dart';



class FlutterwavePayment extends StatefulWidget {
  final dynamic paymentData;
  const FlutterwavePayment({super.key, this.paymentData});

  @override
  State<FlutterwavePayment> createState() => _FlutterwavePaymentState();
}

class _FlutterwavePaymentState extends State<FlutterwavePayment> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      amountController.text = widget.paymentData['amount'].toString();
    });
  }

  String selectedCurrency = "";

  bool isTestMode = true;

  @override
  Widget build(BuildContext context) {
    this.currencyController.text = this.selectedCurrency;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: "Amount"),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Amount is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.currencyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  onTap: this._openBottomSheet,
                  decoration: InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Currency is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.emailController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  children: [
                    Text("Use Debug"),
                    Switch(
                      onChanged: (value) => {
                        setState(() {
                          isTestMode = value;
                        })
                      },
                      value: this.isTestMode,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,),
                  onPressed: this._onPressed,
                  child: Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = ["NGN", "RWF", "UGX", "KES", "ZAR", "USD", "GHS", "TZS"];
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
                  onTap: () => {this._handleCurrencyTap(currency)},
                  title: Column(
                    children: [
                      Text(
                        currency,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 4),
                      Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
    this.setState(() {
      this.selectedCurrency = currency;
      this.currencyController.text = currency;
    });
    Navigator.pop(this.context);
  }

  Future<void> _onPressed() async {
    final currentState = this.formKey.currentState;
    if (currentState != null && currentState.validate()) {
      final paymentResult = await this._handlePaymentInitialization();
      if (paymentResult != null && paymentResult.status == 'successful') {
        await Future.delayed(Duration(seconds: 3));
           final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
       var data = {
      "user": userAuthProvider.authState.id,
      "event": widget.paymentData!['event'],
      "number": widget.paymentData!['number'],
      "amount":  widget.paymentData!['amount']
    };

 
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
      // setState(() {
      //   isLoading = false;
      // });
    }
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>TicketsScreen()),
          );// Navigate back to orders page with payment success status
        // Proceed with placing the order
      }else{
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>BuyTicketScreen()),
        //   );
      }
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(email: emailController.text);

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: 'FLWPUBK_TEST-ad169f46c21db341e24cbde5816d72bf-X',
        currency: this.selectedCurrency,
        redirectUrl: 'https://facebook.com',
        txRef: Uuid().v1(),
        amount: this.amountController.text.toString().trim(),
        customer: customer,
        paymentOptions: "card, payattitude, barter, bank transfer, ussd",
        customization: Customization(title: "Test Payment"),
        isTestMode: this.isTestMode);
    final ChargeResponse response = await flutterwave.charge();
    this.showLoading(response.toString());
    print("${response.toJson()}");

    return response; // Return the ChargeResponse object
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

}
