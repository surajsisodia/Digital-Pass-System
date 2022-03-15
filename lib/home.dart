import 'package:ccet_qr_scan/person.dart';
import 'package:ccet_qr_scan/success_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? qrController;
  bool isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Permission.camera.request().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     qrController!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     qrController!.resumeCamera();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Expanded(
                child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            )),
            if (isSearching)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    qrController = controller;

    qrController!.scannedDataStream.listen((event) {
      if (event.code != null)
        setState(() {
          print(event.code);
          qrController!.pauseCamera();

          checkPass(event.code!);
        });
    });
  }

  checkPass(String id) async {
    isSearching = true;
    setState(() {});
    final res =
        await FirebaseFirestore.instance.collection('passData').doc(id).get();

    if (res.exists) {
      final person = Person().fromMap(res.data()!);
      await showDialog(
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) {
            return SuccessDialog(
              person: person,
            );
          });
    }

    qrController!.resumeCamera();
    isSearching = false;
    setState(() {});
  }
}
