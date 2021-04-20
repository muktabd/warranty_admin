import 'package:dio/dio.dart';

class ApiModel {
  static Map<String, String> httpHeaders = {
    'Accept': 'application/json, text/plain, */*',
    'Connection': 'keep-alive',
    'Content-Type': 'multipart/form-data, application/json',
    //'User-Agent': 'koala-server',
    'Back-Token': '',
  };

  static Future postJson(Map<String, dynamic> params, String url) async {
    Response response;
    Dio dio = Dio();
    // httpHeaders['Back-Token'] = await StaffModel.getLocalToken();
    dio.options.headers = httpHeaders;
    try {
      response = await dio.post(url, data: params);
      return response.data;
    } catch (e) {
      print(e.toString());
      return {"code": -999, "message": url + "|" + e.toString()};
      // return e.toString();
    }
  }

  // static Future getJson(String url) async {
  static Future<Map<String, dynamic>> getJson(String url) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers = httpHeaders;

    try {
      response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {"code": -999, "desc": "connection failed"};
      }
    } catch (e) {
      print(e.toString());
      return {"code": -999, "message": url + "|" + e.toString()};
      // return e.toString();
    }
  }

  /* 
  * Post FormData
  * In Sender from
  * In User Login
  */

  static Future postData(Map<String, dynamic> body, String url) async {
    Response response;
    Dio dio = Dio();
    dio.options.headers = httpHeaders;

    print('geeting url==> $url');
    print('getting body response===> $body');

    try {
      FormData formData = new FormData.fromMap(body);
      response = await dio.post(url,
          data: formData, options: Options(contentType: "multipart/form-data"));
      return response.data;
    } catch (e) {
      print(e);
    }
  }

/*   static postFormData(Map<String, dynamic> body, String url) async {
    Response response;
    var dio = Dio();
    print('geeting url==> $url');
    print('getting body response===> $body');

     dio.options.headers = httpHeaders;
    
    try {
      var formData = FormData.fromMap(body);
      var response = await dio.post(url, data: formData);
      print('response===> $response');
      return response.data;

      /*   
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response;
      } 
      */
    
  } */

  /*   
  * api with  param 
  * then api get will call like this
  */

/*
  static Future getJson(Map<String, dynamic> params, String url) async {
    Response response;
    Dio dio = Dio();
    print('===> param $params');
    print('===> url $url');

    dio.options.headers = httpHeaders;

    try {
      response = await dio.get(url, queryParameters: params);
      if (response.statusCode == 200) {
        print('200 is ==>${response.data.toString()}');
        return response.data;
      } else {
        return {"code": -999, "desc": "connection failed"};
      }
    } catch (e) {
      print(e.toString());
      return {"code": -999, "message": url + "|" + e.toString()};
      // return e.toString();
    }
  } 
  */
}
