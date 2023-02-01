import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_scanner/model/qr_model.dart';
import 'package:simple_scanner/mvc/view.dart';
import 'package:simple_scanner/pages/download_file.dart';
import 'package:simple_scanner/pages/home_page.dart';
import 'package:simple_scanner/pages/login/login_page.dart';
import 'package:simple_scanner/pages/otp/otp_page.dart';
import 'package:simple_scanner/pages/qr_scanner_page.dart';
import 'package:simple_scanner/pages/splash_page.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
Isar? isar;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  var path = dir.path;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   isar = await Isar.open([
    QrModelSchema
  ], directory: path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
      textPadding: const EdgeInsets.all(10),
      child: Sizer(builder:  (context, orientation, deviceType){
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          routes: {
            HelperString.splashPageNav:(context) => const SplashPage(),
            HelperString.loginPageNav:(context) => const LoginPage(),
            HelperString.otpPageNav:(context) =>  OtpPage(arguments: ModalRoute.of(context)?.settings.arguments,),
            HelperString.homePageNav:(context) =>  const HomePage(),
            HelperString.qrViewPage:(context) => const QrScannerPage()
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MvcView(),
        );

      }),
    );
  }
}


