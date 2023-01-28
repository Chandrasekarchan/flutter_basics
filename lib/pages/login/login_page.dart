import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_scanner/components/custom_button.dart';
import 'package:simple_scanner/components/input_fields.dart';
import 'package:simple_scanner/components/loader_helper.dart';
import 'package:simple_scanner/pages/login/login_vm.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = LoginVm();
  DateTime time = DateTime.now();
  final LoaderHelper loaderHelper = LoaderHelper();
  final numberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      var difference = DateTime.now().difference(time);
      final isWarning = difference >= const Duration(seconds: 3);
      time = DateTime.now();
      if (isWarning) {
        showToast("Press back again to exit");
        return false;
      } else {
        return true;
      }
    }, child: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.25,
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: HelperString.poppinsBold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      padding: EdgeInsets.only(
                        left: constraints.maxWidth * 0.08,
                        right: constraints.maxWidth * 0.08,
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Phone Number",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: HelperString.poppinsMedium),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: constraints.maxHeight*0.008),
                              child: phoneNumberField(numberController, "0987654321", viewModel.numberError,autoFocus: true)),
                          Container(
                              margin: EdgeInsets.only(top: constraints.maxHeight*0.04),
                              width: constraints.maxWidth*0.4,
                              child: standardButton(() async{
                                String isValidated = viewModel.validateNumber(numberController.text);
                                if(isValidated.isNotEmpty){
                                  setState(() {
                                    viewModel.numberError = isValidated;
                                  });
                                }else{
                                  setState(() {
                                    viewModel.numberError = null;
                                  });
                                  FocusScope.of(context).unfocus();
                                  verifyPhoneNumber();
                                }
                              }, "Login"))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    ));
  }
  
  void verifyPhoneNumber() async{
    loaderHelper.showLoader(context);
    await auth.verifyPhoneNumber(
      phoneNumber: "+91${numberController.text}",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        loaderHelper.hideLoader(context);
    }, verificationFailed: (FirebaseAuthException e) {
        print("firebaseError: ${e}");
      loaderHelper.hideLoader(context);
      showToast("Some thing went wrong please try again later");
    }, codeSent: (String verificationId, int? resendToken) async {
      loaderHelper.hideLoader(context);
      // Update the UI - wait for the user to enter the SMS code
      Map<String,String> map = {
        HelperString.verificationId:verificationId,
        HelperString.phoneNumber:numberController.text,
      };
      Navigator.popAndPushNamed(context, HelperString.otpPageNav,arguments: map);
    }, codeAutoRetrievalTimeout: (String verificationId) {  },);
  }
}
