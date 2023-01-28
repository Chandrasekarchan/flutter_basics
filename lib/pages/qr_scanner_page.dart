import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_scanner/model/qr_model.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final qrKey = GlobalKey(debugLabel: "QR");
  Barcode? barcode;
  QRViewController? controller;
  String type = "Text";
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        onQRViewCreated: onQrViewCreated,
        key: qrKey,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          borderColor: Colors.blue,
          borderLength: 20,
          borderWidth: 5,
          borderRadius: 20,
        ),
      ),
    );
  }

  void onQrViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((event) {
      barcode = event;
      showConfirmationDialog();
    });
  }

  showConfirmationDialog() {
    controller?.pauseCamera();
    String msg = "Do you want to save the details";
    if (barcode != null && barcode?.code != null) {
      try {
        String barcodeData = barcode!.code!;
        print("something: ${barcode?.code}");
        Uri uri = Uri.parse(barcodeData);
        var data = uri.host.split(".");
        var domain = data.sublist(1).join('.');
        if (domain.isNotEmpty) {
          msg = "Do you want to save the details hosted by $domain";
          type = "url";
        } else {
          var data = barcode!.code!.split(":");
          if (data.isNotEmpty) {
            String item = data[0];
            print("selectedItem: $item");
            switch (item) {
              case HelperString.mail:
                msg = "Do you want to save the mail";
                type = "Mail";
                break;
              case HelperString.phone:
                {
                  msg = "Do you want to save this phone number ${data[1]}";
                  type = "Mobile number";
                }
                break;
              case HelperString.meCard:
                msg = "Do you want to save this MeCard";
                type = "MeCard";
                break;
              case HelperString.wifi:
                msg = "Do you want to save this wifi";
                type = "Wifi";
                break;
              case HelperString.upi:
                msg = "Do you want to save this upi";
                type = "upi";
                break;
              case HelperString.begin:
                var secondItem = data[1].split(("\n"));
                if (secondItem[0] == HelperString.event) {
                  msg = "Do you want to save this event";
                  type = "Event";
                } else {
                  msg = "Do you want to save the details";
                }
                break;
              default:
                msg = "Do you want to save the details";
            }
          }
        }
      } catch (e) {
        msg = "Do you want to save the details";
      }
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            AlertDialog(
              backgroundColor: Colors.white,
              alignment: Alignment.center,
              elevation: 20,
              title: Text(
                msg,
                style: const TextStyle(fontFamily: HelperString.poppinsMedium),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                TextButton(
                    onPressed: () {
                      QrModel model = QrModel(
                          barcode?.code ?? "", barcode?.format.formatName ?? "",
                          barcode?.rawBytes ?? [], type);
                      Navigator.pop(context);
                      Navigator.pop(context, model);
                    },
                    child: Text("Ok",
                        style: TextStyle(
                            fontFamily: HelperString.poppinsRegular,
                            fontSize: 12.sp))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller?.resumeCamera();
                    },
                    child: Text("cancel",
                        style: TextStyle(
                            fontFamily: HelperString.poppinsRegular,
                            fontSize: 12.sp))),
              ],
            ));
  }
}
