import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:simple_scanner/components/input_fields.dart';
import 'package:simple_scanner/components/loader_helper.dart';
import 'package:simple_scanner/pages/otp/otp_vm.dart';
import 'package:simple_scanner/providers/helper_string.dart';
import 'package:sizer/sizer.dart';

import '../../components/custom_button.dart';

class OtpPage extends StatefulWidget {
  final arguments;
  const OtpPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final viewModel = OtpViewModel();
  final otpController = TextEditingController();
  String verificationId = "";
  String phoneNumber ="";
  final loaderHelper = LoaderHelper();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    viewModel.startTimer();
    if(widget.arguments != null){
      if(widget.arguments is Map<String,String>){
        verificationId = widget.arguments[HelperString.verificationId];
        phoneNumber = widget.arguments[HelperString.phoneNumber];
      }
    }
    super.initState();
  }
  @override
  void dispose() {
    otpController.dispose();
    if(viewModel.timer != null){
      viewModel.timer?.cancel();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                        "OTP",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Enter OTP",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: HelperString.poppinsMedium),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.008),
                              width: constraints.maxWidth * 0.6,
                              child: otpField(
                                  otpController, "123456", viewModel.otpError)),
                          Container(
                              margin: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.008),
                              width: constraints.maxWidth * 0.6,
                              child: InkWell(
                                onTap: (){
                                  if(viewModel.timerCompleted){
                                    resendOtp();
                                    viewModel.startTimer();
                                  }
                                },
                                child: Obx(() => Text(
                                    "Didint receive OTP? ${viewModel.timerTxt.value}",style: TextStyle(
                                  color: Colors.black,fontSize: 11.sp,fontFamily: HelperString.poppinsRegular
                                ),),),
                              )),
                          Container(
                              margin: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.04),
                              width: constraints.maxWidth * 0.4,
                              child: standardButton(() {
                                String txt = viewModel.validateOtp(otpController.text);
                                if(txt.isNotEmpty){
                                  setState(() {
                                    viewModel.otpError = txt;
                                  });
                                }else{
                                  setState(() {
                                    viewModel.otpError = null;
                                  });
                                  FocusScope.of(context).unfocus();
                                  submitOtp();
                                }
                              }, "Submit"))
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
    );
  }
  void submitOtp() async{
    loaderHelper.showLoader(context);
  var  _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);
  auth.signInWithCredential(_credential).then((value){
    loaderHelper.hideLoader(context);
    Navigator.popAndPushNamed(context, HelperString.homePageNav);
  }).onError((error, stackTrace) {
    loaderHelper.hideLoader(context);
    showToast(error.toString());
  });
  }

  void resendOtp() async{
    loaderHelper.showLoader(context);
    await auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        loaderHelper.hideLoader(context);
      }, verificationFailed: (FirebaseAuthException e) {
      print("firebaseError: ${e}");
      loaderHelper.hideLoader(context);
      showToast("Some thing went wrong please try again later");
    }, codeSent: (String verificationId, int? resendToken) async {
      loaderHelper.hideLoader(context);
      verificationId = verificationId;
    }, codeAutoRetrievalTimeout: (String verificationId) {  },);
  }
}
