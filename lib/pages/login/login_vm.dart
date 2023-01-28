class LoginVm{
  String? numberError;
  String validateNumber(String number){
    String validater = "";
    if(number.isEmpty){
      validater = "Number is required";
    }else if(number.length<10){
      validater = "Not a valid number";
    }else{
      validater = "";
    }
    return validater;
  }
}