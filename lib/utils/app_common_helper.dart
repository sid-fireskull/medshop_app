import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppCommonHelper {
  static String formatDate(String date, {String dateFormat}) {
    DateFormat formattedDate;
    if (date == null || date == "") {
      return "";
    }
    if (dateFormat == null) {
      formattedDate = DateFormat("yyyy-MM-dd");
    }
    formattedDate = DateFormat(dateFormat);
    return formattedDate.format(DateTime.parse(date).toLocal());
  }

  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static void customToast(String message) {
    Fluttertoast.showToast(
        msg: message ?? "",
        toastLength: Toast.LENGTH_LONG,
        webBgColor: "linear-gradient(to right, #05adf0, #05adf0)",
        textColor: Colors.white,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red.shade600);
  }

  static Future<FilePickerResult> pickCSV() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: "Select CSV File");
    return result;
  }
}
