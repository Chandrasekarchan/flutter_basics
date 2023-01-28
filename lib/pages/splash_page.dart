import 'package:flutter/material.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    waitAndClose();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Hello",
          style: TextStyle(
              color: Colors.black,
              fontSize: 22.sp,
              fontFamily: HelperString.poppinsBold),
        ),
      ),
    );
  }

  void waitAndClose(){
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.popAndPushNamed(context, HelperString.loginPageNav);
    });
  }
}
