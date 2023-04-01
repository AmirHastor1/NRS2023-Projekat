import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nrs2023/screens/transactionDetails.dart';
import 'package:nrs2023/screens/filters.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  late String date;
  late String type;
  late double amount;
  late String id;
  late String currency;
  late String details;
  late String recipientN;
  late String recipientAcc;

  // constructor
  Transaction(this.date, this.type, this.amount, this.currency, this.details,
      this.id, this.recipientN, this.recipientAcc);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['date'],
      json['type'],
      json['amount'].toDouble(),
      json['id'],
      json['currency'],
      json['details'],
      json['recipientN'],
      json['recipientAcc'],
    );
  }
}

class Transactions extends StatefulWidget {
  @override
  InitalState createState() => InitalState();
}

class InitalState extends State<Transactions> {
  late List<Transaction> transactions;
  final showntransactions = <Transaction>[];
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  String searchValue = '';

//KOD Za povlacenje tranzakcija sa API-a

/*
  @override
  void initState() {
    super.initState();
    transactions = [];
    _getMoreTransactions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreTransactions();
      }
    });
  }
*/

//KOD za dummy podatke
  @override
  void initState() {
    //TODO: implement initState from Backend
    super.initState();
    transactions = List.generate(
      10,
      (index) => Transaction(
          'Jan ${index + 1} 2021',
          'Transfer',
          100.0 + (index * 10),
          'EUR',
          'detail',
          '12345',
          'Enes',
          '0987654321123456'),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreList();
        showntransactions.clear();
        for (int i = 0; i < transactions.length; i++) {
          showntransactions.add(transactions[i]);
        }
      }
    });
    for (int i = 0; i < transactions.length; i++) {
      showntransactions.add(transactions[i]);
    }
  }

  _getMoreList() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      transactions.add(Transaction(
          'Jan ${i + 1} 2021',
          'Transfer',
          100.0 + (i * 10),
          'EUR',
          'detail',
          '12345',
          'Enes',
          '0987654321123456'));
    }
    _currentMax = _currentMax + 10;
    setState(() {});
  }
//KOD za dummy podatke

//KOD za podatke sa servera
  Future<void> _getMoreTransactions() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    //URL ce se promijeniti kada RI završti backend
    final url = Uri.parse('https://my-api.com/transactions?page=$_currentPage');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final List<Transaction> loadedTransactions = [];
    responseData['data'].forEach((transactionData) {
      loadedTransactions.add(Transaction.fromJson(transactionData));
    });
    setState(() {
      transactions.addAll(loadedTransactions);
      _isLoading = false;
      _currentPage++;
    });
  }

//KOD za podatke sa servera
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text("All Transactions"),
        onSearch: (value) => setState(() {
          searchValue = value;
          showntransactions.clear();
          for (int i = 0; i < transactions.length; i++) {
            if (transactions[i].details.contains(searchValue)) {
              showntransactions.add(transactions[i]);
            }
          }
        }),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Filter Transactions',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FiltersScreen()));
              }),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sort by"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Amount (ascending)"),
                        onTap: () {
                          // Sort transactions by amount (ascending)
                          setState(() {
                            transactions
                                .sort((a, b) => a.amount.compareTo(b.amount));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Amount (descending)"),
                        onTap: () {
                          // Sort transactions by amount (descending)
                          setState(() {
                            transactions
                                .sort((a, b) => b.amount.compareTo(a.amount));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (ascending)"),
                        onTap: () {
                          // Sort transactions by date (ascending)
                          setState(() {
                            transactions
                                .sort((a, b) => a.date.compareTo(b.date));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Date (descending)"),
                        onTap: () {
                          // Sort transactions by date (descending)
                          setState(() {
                            transactions
                                .sort((a, b) => b.date.compareTo(a.date));
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemExtent: 85,
        itemBuilder: (context, index) {
          if (index == showntransactions.length) {
            return const CupertinoActivityIndicator();
          }
          return ListTile(
            title: Text(showntransactions[index].date),
            subtitle: Text(showntransactions[index].type),
            trailing: Text(showntransactions[index].amount.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailsScreen(
                      transactionId: showntransactions[index].id,
                      transactionCurrency: showntransactions[index].currency,
                      transactionType: showntransactions[index].type,
                      transactionAmount: showntransactions[index].amount,
                      transactionDate: showntransactions[index].date,
                      transactionDetails: showntransactions[index].details,
                      recipientName: showntransactions[index].recipientN,
                      recipientAccount: showntransactions[index].recipientAcc),
                ),
              );
            },
          );
        },
        itemCount: showntransactions.length + 1,
      ),
    );
  }
}
