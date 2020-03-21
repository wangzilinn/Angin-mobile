import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

class HttpService {
  static const HOST = "https://47.103.194.29";
  static const PORT = "8443";
  static const header = {'Content-Type': "application/json"};

  //私有证书验证
  static bool _certificateCheck(X509Certificate cert, String host, int port) =>
      host == '47.103.194.29';

  static var ioClient = new HttpClient()
    ..badCertificateCallback = _certificateCheck;
  var _client = IOClient(ioClient);

  get url => HOST + ":" + PORT + "/";

  Future<Response> get(dynamic api, {Map<String, String> headers}) {
    if (headers == null) headers = header;
    return _client.get(url + api, headers: header);
  }

  Future<Response> post(dynamic api,
      {Map<String, String> headers, body, Encoding encoding}) {
    if (headers == null) headers = header;
    return _client.post(url + api,
        headers: headers, body: body, encoding: encoding);
  }

  Future<Response> put(dynamic api,
      {Map<String, String> headers, body, Encoding encoding}) {
    if (headers == null) headers = header;
    return _client.put(url + api,
        headers: headers, body: body, encoding: encoding);
  }

  Future<Response> delete(dynamic api, {Map<String, String> headers}) {
    if (headers == null) headers = header;
    return _client.delete(url + api, headers: headers);
  }
}
