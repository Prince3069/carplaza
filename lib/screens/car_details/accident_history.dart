import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AccidentHistoryScreen extends StatefulWidget {
  final String carId;

  const AccidentHistoryScreen({Key? key, required this.carId})
      : super(key: key);

  @override
  State<AccidentHistoryScreen> createState() => _AccidentHistoryScreenState();
}

class _AccidentHistoryScreenState extends State<AccidentHistoryScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;
  String? _scanResult;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcodeScan(Barcode barcode) {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
      _scanResult = barcode.rawValue;
    });

    // Here you would typically verify the QR code with your backend
    // and fetch the accident history for the car
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scan result: ${barcode.rawValue}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident History Check'),
      ),
      body: Column(
        children: [
          if (_scanResult == null)
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        _handleBarcodeScan(barcodes.first);
                      }
                    },
                  ),
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Scan the car\'s accident history QR code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _isScanning = true);
                      },
                      child: Text(_isScanning ? 'Scanning...' : 'Start Scan'),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      'Scan Successful',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _scanResult!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _scanResult = null;
                          _isScanning = false;
                        });
                      },
                      child: const Text('Scan Again'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
