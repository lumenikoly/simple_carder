import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:simple_carder/logic/bloc/card_bloc.dart';
import 'package:simple_carder/logic/bloc/card_event.dart';
import 'package:simple_carder/model/barcode_item.dart';

class CardGenerator extends StatefulWidget {
  final CardBloc cardBloc;
  CardGenerator({@required this.cardBloc});
  @override
  _CardGeneratorState createState() => _CardGeneratorState();
}

class _CardGeneratorState extends State<CardGenerator> {
  final _textController = TextEditingController();
  String _name = "";
  String _scanBarcode = "";
  bool _visibleScanButtonFlag = true;
  bool _visibleCodeBarFlag = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    String barcodeScanRes;
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version';
    }
    if (!mounted || barcodeScanRes == '') return;
    setState(() {
      _scanBarcode = barcodeScanRes;
      _barCodeItem.codeStr = _scanBarcode;
      _visibleScanButtonFlag = false;
      _visibleCodeBarFlag = true;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _addCard() {
    setState(() {
      _name = _textController.text;
      _barCodeItem = BarCodeItem(codeStr: _scanBarcode, description: _name);
      widget.cardBloc.dispatch(AddScanCard(_barCodeItem));
    });
  }

  BarCodeItem _barCodeItem = BarCodeItem(
      type: BarCodeType.CodeEAN13,
      codeStr: "null",
      description: "null",
      hasText: true);

  bool _checkCard(String scanBarcode, String name, BuildContext context) {
    final SnackBar needScan = SnackBar(content: Text('Сканируйте карточку!'));
    if (scanBarcode != "" && name != "") {
      _addCard();
      return true;
    } else if (scanBarcode == "") {
      Scaffold.of(context).showSnackBar(needScan);
      return false;
    } else if (name == "") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Введите название')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Добавить карточку'),
        ),
        body: Builder(
            builder: (context) => Column(
                  children: <Widget>[
                    Text(_textController.text),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Visibility(
                            visible: _visibleCodeBarFlag ? true : false,
                            child: BarCodeImage(
                                data: _barCodeItem.codeStr,
                                codeType: _barCodeItem.type,
                                lineWidth: 2.0,
                                barHeight: 100.0,
                                hasText: _barCodeItem.hasText,
                                onError: (error) {
                                  print(
                                      "Ошибка генерации штрих кода. Код ошибки: $error");
                                }))),
                    Visibility(
                      visible: _visibleScanButtonFlag ? true : false,
                      child: Expanded(
                        flex: 1,
                        child: FlatButton(
                          onPressed: () {
                            initPlatformState();
                          },
                          child: Text('Сканировать карту',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            onChanged: (name) {
                              _name = name;
                            },
                            controller: _textController,
                            maxLength: 15,
                            decoration: InputDecoration(
                                helperText: 'Введите название карты',
                                prefixIcon: Icon(Icons.credit_card)),
                          ),
                        )),
                    Expanded(
                      child: FlatButton(
                        child: Text(
                          'Добавить карту',
                          style: Theme.of(context).textTheme.display1,
                        ),
                        onPressed: () {
                          if (_checkCard(_scanBarcode, _name, context)) {
                            Banner(
                              location: BannerLocation.bottomEnd,
                              message: 'Карта добавлена!',
                            );
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                )));
  }
}
