import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:simple_carder/model/barcode_item.dart';

class CardBarcode extends StatefulWidget {
  CardBarcode({Key key, @required this.barCodeItem}) : super(key: key);
  final BarCodeItem barCodeItem;
  final String title = "BarCode Flutter";

  @override
  _CardBarcodeState createState() => _CardBarcodeState();
}

class _CardBarcodeState extends State<CardBarcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text( widget.barCodeItem.description,)),
        body: Padding(
      padding: EdgeInsets.only(top: 30),
      child: Container(
          child: Column(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Text(
            'Хорошего настроения',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.body2
          ),
        ),
        Center( child:
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Container(
              color: Colors.transparent,
          padding: EdgeInsets.all(10.0),
          child: BarCodeImage(
            data: widget.barCodeItem.codeStr,
            codeType: widget.barCodeItem.type,
            lineWidth: 2.0,
            barHeight: 100.0,
            hasText: widget.barCodeItem.hasText,
            onError: (error) {
              print("Ошибка генерации штрих кода. Код ошибки: $error");
            },
          ),
        )))
      ])),
    ));
  }
}
