import 'dart:async';

import 'package:get/get.dart';

class OtpViewModel{
  RxString timerTxt = "".obs;
   Timer? timer;
  int _start = 60;
  bool timerCompleted = false;
  String? otpError;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer =  Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          timerTxt.value = "Resend OTP";
          timerCompleted = true;
        } else {
          _start --;
          timerCompleted = false;
          if(_start <10){
            timerTxt.value = "Resend in 0$_start";
          }else{
            timerTxt.value = "Resend in $_start";
          }
        }
      },
    );
  }
  String validateOtp(String otp){
    String validater = "";
    if(otp.isEmpty){
      validater = "OTP is required";
    }else if(otp.length < 6){
      validater = "OTP must be six digits";
    }
    return validater;
  }
}