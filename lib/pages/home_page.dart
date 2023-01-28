import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_scanner/components/loader_helper.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';
import '../model/qr_model.dart';
import '../providers/helper_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxList<QrModel> qrsList = RxList();
  DateTime time = DateTime.now();
  final LoaderHelper loaderHelper = LoaderHelper();

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      getOldData();
    });
    super.initState();
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
    }, child: LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Qr Scanner"),
          ),
          body: Obx(
                () => qrsList.isNotEmpty
                ? Obx(() => ListView.builder(
                itemCount: qrsList.length,
                itemBuilder: (lContext, index) {
                  var item = qrsList[index];
                  return InkWell(
                    onTap: () async{
                       showDialog(context: context,
                          barrierDismissible: false,
                          builder:(_)=> AlertDialog(
                            backgroundColor: Colors.white,
                            alignment: Alignment.center,
                            elevation: 20,
                            title: const Text("Are you sure to delete",style: TextStyle(fontFamily: HelperString.poppinsMedium),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                                removeFromdDataBase(item.id ?? 0, index);
                              }, child:  Text("Ok",style: TextStyle(fontFamily: HelperString.poppinsRegular,fontSize: 12.sp))),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child:  Text("cancel",style: TextStyle(fontFamily: HelperString.poppinsRegular,fontSize: 12.sp))),
                            ],
                          ) );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey,width: 2),
                      ),
                      margin: EdgeInsets.only(
                        top: constraints.maxHeight*0.008,
                        bottom: constraints.maxHeight*0.008,
                        left: constraints.maxWidth*0.02,
                        right: constraints.maxWidth*0.02,
                      ),
                      padding: EdgeInsets.only(
                          top: constraints.maxHeight * 0.02,
                          bottom: constraints.maxHeight * 0.02,
                          left: constraints.maxWidth * 0.04,
                          right: constraints.maxWidth * 0.04,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("QrFormat: ${item.formatName}",style: TextStyle(
                              color: Colors.black, fontSize: 14.sp,fontFamily: HelperString.poppinsRegular),),
                          Container(
                              margin: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.02),
                              child: Text(
                                "QrData: ${item.data}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.sp,fontFamily: HelperString.poppinsRegular),
                              )),
                          Container(
                              margin: EdgeInsets.only(
                                  top: constraints.maxHeight * 0.02),
                              child: Text(
                                "QrType: ${item.type}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.sp,fontFamily: HelperString.poppinsRegular),
                              )),
                        ],
                      ),
                    ),
                  );
                }))
                : Center(
                child: Text(
                  "No qrs found",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: HelperString.poppinsMedium,
                      fontSize: 14.sp),
                )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool isPermissionGranted = await Permission.camera.isGranted;
              if (isPermissionGranted) {
                goToScanQr();
              } else {
                await Permission.camera.request().then((value) {
                  goToScanQr();
                });
              }
              },
            child: Icon(Icons.camera_alt_outlined),
          ));
    }));
  }

  goToScanQr() {
    Navigator.pushNamed(context, HelperString.qrViewPage).then((value) async {
      if (value is QrModel) {
        loaderHelper.showLoader(context);
       await isar!.writeTxn(() async {
          isar!.qrModels.put(value);
        });
        await isar!.qrModels.where().findAll().then((value) {
          if (value.isNotEmpty) {
              qrsList.value = value;
          }
        });
        hideLoader();
      }
    });
  }

  void hideLoader() {
    loaderHelper.hideLoader(context);
  }

  void removeFromdDataBase(int id,int index) async{
    loaderHelper.showLoader(context);
    isar!.writeTxn(() async{
      isar!.qrModels.delete(id);
    });
    qrsList.removeAt(index);
    hideLoader();
  }

  void getOldData() async{
    loaderHelper.showLoader(context);
    isar!.qrModels.where().findAll().then((value){
      if(value.isNotEmpty){
        qrsList.value = value;
      }
    });
    hideLoader();
  }
}
