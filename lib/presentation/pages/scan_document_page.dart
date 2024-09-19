import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:verified/helpers/logger.dart';

class ScanDocumentPage extends StatefulWidget {
  const ScanDocumentPage({super.key});

  @override
  State<ScanDocumentPage> createState() => _ScanDocumentPageState();
}

class _ScanDocumentPageState extends State<ScanDocumentPage> {

  bool isParsed = false;
  MRZController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MRZScanner(
        withOverlay: true,
        onControllerCreated: onControllerCreated,
      ),
    );
  }

  @override
  void dispose() {
    controller?.stopPreview();
    super.dispose();
  }

  void onControllerCreated(MRZController controller) {
    this.controller = controller;
    controller.onParsed = (result) async {
      if (isParsed) {
        return;
      }
      isParsed = true;

      await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
                  content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Document type: ${result.documentType}'),
                  Text('Country: ${result.countryCode}'),
                  Text('Surnames: ${result.surnames}'),
                  Text('Given names: ${result.givenNames}'),
                  Text('Document number: ${result.documentNumber}'),
                  Text('Nationality code: ${result.nationalityCountryCode}'),
                  Text('BirthDate: ${result.birthDate}'),
                  Text('Sex: ${result.sex}'),
                  Text('Expiry date: ${result.expiryDate}'),
                  Text('Personal number: ${result.personalNumber}'),
                  Text('Personal number 2: ${result.personalNumber2}'),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      isParsed = false;
                      return Navigator.pop(context, true);
                    },
                  ),
                ],
              )));
    };
    controller.onError = (error) => verifiedErrorLogger(error, StackTrace.current);

    controller.startPreview();
  }
}
