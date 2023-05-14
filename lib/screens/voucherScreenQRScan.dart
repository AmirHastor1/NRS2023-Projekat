import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VoucherScreenQRScan extends StatefulWidget {
  @override
  _VoucherScreenQRScanState createState() => _VoucherScreenQRScanState();
}

class _VoucherScreenQRScanState extends State<VoucherScreenQRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final storage = new FlutterSecureStorage();
  QRViewController? controllerZaQRCode;
  String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Text('Scanned QR Code: $qrText'),
        ],
      ),
    );
  }

  //potrebno uraditi get za voucher code koji se skenira da se moze dodati amount

  Future<void> ExecuteVoucherRedemption(String amount,
      String accountNumber) async {
    String? token = await storage.read(key: 'token');

    final uri = Uri.parse(
        "https://processingserver.herokuapp.com/api/Voucher/ExecuteVoucherRedemption?token=$token");

    final body = {
      "amount": amount,
      "accountNumber": accountNumber,
    };

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    final response =
    await http.post(uri, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      print('Voucher redemption successful');
    } else {
      print('Voucher redemption failed');
    }
  }

  @override
  void dispose() {
    controllerZaQRCode?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controllerZaQRCode = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
    });
  }
}
