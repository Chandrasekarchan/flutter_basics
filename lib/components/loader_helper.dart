import 'package:flutter/material.dart';

class LoaderHelper{
  DialogRoute? route;
  bool isLoading =false;
  void showLoader(BuildContext context){
    if(!isLoading){
      route = DialogRoute(
          context: context,
          builder: (_)=>_transLoader(context),
          barrierDismissible: false
      );
      Navigator.of(context).push(route!);
      isLoading = true;
    }
  }
  void hideLoader(BuildContext context){
    if(route != null){
      isLoading = false;
      Navigator.of(context).removeRoute(route!);
      route = null;
    }
  }
  Widget _transLoader(BuildContext context){
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        alignment: FractionalOffset.center,
        height: 80.0,
        padding: const EdgeInsets.all(20.0),
        child:  const CircularProgressIndicator(),
      ),
    );
  }
}