import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_scanner/components/loader_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_scanner/networkProviders/api_service.dart';
import 'package:open_filex/open_filex.dart';

class FileDownloader extends StatefulWidget {
  const FileDownloader({Key? key}) : super(key: key);

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);
  final dio = Dio();
  final url = "https://research.nhm.org/pdfs/10840/10840-001.pdf";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () async {
          _showMyDialog();
           await dio.get(url,
              options: Options(
                responseType: ResponseType.bytes,
              ), onReceiveProgress: (count, total) {
            print("count: $count , total: $total");
            int percentage = ((count / total) * 100).floor();
            _progress.value = percentage.toDouble();

          }).then((value){
            Navigator.pop(context);
            final bytes = value.data;
            saveFile(url, bytes).then((value){
            //  OpenFilex.open(value.path);
            });
          });

        },
        child: Text("Hellow world"),
      ),
    ));
  }

  Future<void> _showMyDialog() async {
    await showDialog(
        context: context,
        builder: (_) {
          return SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: ValueListenableBuilder(
                    valueListenable: _progress,
                    builder: (BuildContext context, double value, Widget? child) {
                      print("progressValue: ${value}");
                      return LinearProgressIndicator(minHeight: 15,value: value,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation<Color>(Colors.red),);
                    },
                  )),
            ),
          );
        });
  }

  Future<File> saveFile(String url, List<int> bytes) async {
    await Permission.storage.request();
    Directory? root =
        await DownloadsPath.downloadsDirectory(); // this is using path_provider
    final file = File("${root!.path}/somePdf.pdf");
    bool value = await file.exists();
    print("isExists: $value");
    await file.writeAsBytes(bytes);
    print("file:${file.absolute}");
    return file;
  }
}
