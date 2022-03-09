import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:medshop/config/app_const_config.dart';
import 'package:medshop/exceptions/auth_exception.dart';
import 'package:medshop/exceptions/privilege_exception.dart';
import 'package:medshop/exceptions/redirection_exception.dart';
import 'package:medshop/exceptions/server_exception.dart';
import 'package:medshop/exceptions/validation_exception.dart';
import 'package:medshop/utils/app_common_helper.dart';
import '../main.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class ApiClient with RouteAware {
  final String baseUrl = "${AppConstConfig.baseUrl}/api/v1";
  Map<String, String> _headers;
  static StreamController<dynamic> validationErrorStreamController =
      StreamController.broadcast();
  static BuildContext currentContext;
  static int _overlayCount = 0;
  static OverlayEntry _overlay;

  getHeader() async {
    _headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      //  "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
    };
    //   print(_headers);
  }

  //   Future makePostRequest() async {
  //   String url = 'your end point';
  //   var headers = {
  //     //YOUR HEADERS
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.headers.addAll(headers);
  //   Uint8List data = await this.image.readAsBytes();
  //   List<int> list = data.cast();
  //   request.files.add(http.MultipartFile.fromBytes('your_field_name', list,
  //       filename: 'myFile.png'));

  //   // Now we can make this call

  //   var response = await request.send();
  //   //We've made a post request...
  //   //Let's read response now

  //   response.stream.bytesToString().asStream().listen((event) {
  //     var parsedJson = json.decode(event);
  //     print(parsedJson);
  //     print(response.statusCode);
  //     //It's done...
  //   });
  // }

  Future<http.Response> multipartFileUpload(
      String url, PlatformFile platformFile) async {
    AppCommonHelper.customToast("Uploading Please Wait...");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
      Uint8List data = platformFile.bytes;
      http.MultipartFile mFile = http.MultipartFile.fromBytes(
          "file", data.cast(),
          filename: platformFile.name,
          contentType: MediaType("multipart", "form-data"));
      request.files.add(mFile);
      var stRes = await request.send();
      http.Response res = await http.Response.fromStream(stRes);
      return _responseManager(res);
    } catch (e) {
      print(e);
    }
  }

  // Future<http.Response> multipartFileUpload(
  //     String url, PlatformFile platformFile) async {
  //   var formData = FormData.fromMap({
  //     'file': MultipartFile.fromBytes(platformFile.bytes,
  //         filename: platformFile.name),
  //   });
  //   Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  //   dio.post(url, data: formData).then((val) {
  //     print(val.data);
  //     print(val.statusMessage);
  //     Response rs = Response(requestOptions: val.requestOptions);
  //     return rs;
  //   });
  //}

  Future<http.Response> postRequest(String url, String content) async {
    await getHeader();
    return http
        .post(Uri.parse(baseUrl + url), body: content, headers: _headers)
        .then(
      (response) {
        return _responseManager(response);
      },
    ).catchError(_onUnknownError);
  }

  Future<http.Response> getRequest(String url, String content,
      {bool isCompleteUrl}) async {
    await getHeader();
    return http
        .get(
            Uri.parse((isCompleteUrl == null || isCompleteUrl == false)
                ? baseUrl + url + content
                : url + content),
            headers: _headers)
        .then(
      (response) async {
        return _responseManager(response);
      },
    ).catchError(_onUnknownError);
  }

  Future<http.Response> putRequest(String url, String content) async {
    await getHeader();
    Map<String, String> extraHeaders = Map.from(_headers);
    extraHeaders["X-HTTP-Method-Override"] = "PUT";
    return http
        .post(Uri.parse(baseUrl + url), body: content, headers: extraHeaders)
        .then(
      (response) {
        return _responseManager(response);
      },
    ).catchError(_onUnknownError);
  }

  http.Response _responseManager(http.Response response) {
    // print(response.statusCode);
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 422) {
      var errors = json.decode(response.body);
      validationErrorStreamController.add(errors);
      throw ValidationException(errors);
    } else if (response.statusCode == 403) {
      var e = AuthException("UnAuthorized");
      throw e;
    } else if (response.statusCode == 427) {
      var errors = json.decode(response.body);
      Fluttertoast.showToast(
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          msg: errors['message']);
      throw errors;
    } else if (response.statusCode == 430) {
      throw RedirectionException(response.body);
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: response.body);
      throw PrivilegeException(response.body);
    } else {
      Fluttertoast.showToast(msg: response.body);
      throw ServerException(response.body);
    }
  }

  _onUnknownError(error) {
    _hideOverLay();
    if (error is SocketException) {
      Fluttertoast.showToast(
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          msg: error.message + " Check Your Internet Connection.");
      //   SystemNavigator.pop();
      return;
    }
    throw error;
  }

  _showOverlay() {
    if (_overlay != null) {
      _overlayCount++;
      return;
    }
    _overlayCount = 1;
    _overlay = OverlayEntry(
      builder: (BuildContext context) => Positioned.fill(child: Container()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(currentContext).insert(_overlay);
      routeObserver.subscribe(this, ModalRoute.of(currentContext));
    });
  }

  _hideOverLay() {
    _overlayCount--;

    if (_overlayCount < 1 && _overlay != null) {
      _overlayCount = 0;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_overlayCount > 0 || _overlay == null) return;
        routeObserver.unsubscribe(this);
        try {
          _overlay.remove();
        } catch (e) {
          print(e);
        }

        _overlay = null;
      });

      //Overlay.of(currentContext).dispose();
    }
  }

  @override
  void didPopNext() {
    _hideOverLay();
  }
}
