import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

class BarCodeItem {
  int id;
  BarCodeType type = BarCodeType.CodeEAN13;
  String codeStr;
  String description;
  bool hasText = true;
  BarCodeItem(
      {this.type: BarCodeType.CodeEAN13,
      @required this.codeStr,
      @required this.description,
      this.hasText: true});

  Map<String, dynamic> toMap() {
    return {
      'codeStr': codeStr,
      'description': description,
    };
  }

  static BarCodeItem fromMap(Map<String, dynamic> map) {
    return BarCodeItem(
        codeStr: map['codeStr'], description: map['description']);
  }
}
