import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nrs2023/screens/accountList.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nrs2023/screens/pay.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/accountCreation.dart';
import 'package:nrs2023/screens/transactions.dart';
import 'package:nrs2023/screens/logIn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth_provider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('LOGOUT'),
                    content: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () {
                          // kod za brisanje pohranjenih korisničkih podataka

                          // navigacija na stranicu prijave
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const logIn()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Text(
            'Welcome to the Home Screen!',
            style: TextStyle(fontSize: 24.0),
          ),

       ],
      ) ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Transactions',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => accountCreation(
                  )),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountListPage(
                      currency: ["", "", "", ""],
                      bankName: '',
                      description: '',
                        )),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Transactions(
                        filterDateStart: DateTime.utc(1900, 1, 1),
                        filterDateEnd: DateTime.now(),
                        filterCurrency: 'All',
                        filterTransactionType: 'All',
                        filterPriceRangeStart: '0',
                        filterPriceRangeEnd: '100000',
                        filterRecipientName: '',
                        filterRecipientAccount: '',
                        filterSenderName: '',
                        filterCategory: '',
                        filterSortingOrder: 'createdAtAsc')),
              );
              break;
          }
        },
      ),
    );
  }
}
