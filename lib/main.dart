import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_carder/logic/bloc/card_bloc.dart';
import 'package:simple_carder/logic/route_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: CardBloc(),
        child: MaterialApp(
          initialRoute: '/',
          title: 'Cart',
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xff831236),
            accentColor: Color(0xff005f82),
            textTheme: TextTheme( 
              body1: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
              body2: TextStyle(fontSize: 30.0, color: Color(0xff831236), fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
              display1: TextStyle(fontSize: 18.0, color: Color(0xff831236), fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
