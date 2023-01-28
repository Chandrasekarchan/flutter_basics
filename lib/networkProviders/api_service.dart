import 'package:dio/dio.dart';

class ApiService{
  Dio _dio = Dio();
  Future<bool> downloadFile(String url,String path,Function(int, int) progress) async{
    var response = await _dio.download(url, path,onReceiveProgress:progress );
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}