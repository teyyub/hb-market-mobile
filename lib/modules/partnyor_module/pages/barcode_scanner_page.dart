import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool isScanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (isScanned) return;
    final barcode = capture.barcodes.first.rawValue;
    if (barcode != null) {
      isScanned = true;
      Get.back(result: barcode); // return barcode value to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
