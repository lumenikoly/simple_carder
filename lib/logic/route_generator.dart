
import 'package:flutter/material.dart';
import 'package:simple_carder/logic/bloc/card_bloc.dart';
import 'package:simple_carder/model/barcode_item.dart';
import 'package:simple_carder/ui/card_barcode.dart';
import 'package:simple_carder/ui/card_generator.dart';
import 'package:simple_carder/ui/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/CardGenerator':
        if (args is CardBloc) {
          return MaterialPageRoute(
              builder: (_) => CardGenerator(
                    cardBloc: args,
                  ));
        } break;
      case '/CardBarcode':
        if (args is BarCodeItem) {
          return MaterialPageRoute(
              builder: (_) => CardBarcode(
                    barCodeItem: args,
                  ));
        }
    }
  }
}
