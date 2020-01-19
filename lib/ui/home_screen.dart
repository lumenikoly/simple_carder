import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_grid_delegate_ext/flutter_grid_delegate_ext.dart';
import 'package:simple_carder/logic/bloc/card_bloc.dart';
import 'package:simple_carder/logic/bloc/card_event.dart';
import 'package:simple_carder/logic/bloc/card_state.dart';
import 'package:simple_carder/model/barcode_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CardBloc _cardBloc;

  @override
  void initState() {
    super.initState();
    _cardBloc = BlocProvider.of<CardBloc>(context);
    _cardBloc.dispatch(LoadCard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildBody(),
    );
  }

   _deleteDialog(String value, BarCodeItem displayedCard) {
    final AlertDialog dialog = AlertDialog(
      content: Text(value),
      actions: <Widget>[
        FlatButton(
            child: Text('Оставить'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        FlatButton(
            child: Text('Удалить'),
            onPressed: () {
              _cardBloc.dispatch(DeleteCard(displayedCard));
            Navigator.of(context).pop();
            })
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Ваши карточки'),
          IconButton(
            onPressed: () {
              _cardBloc.dispatch(AddRandomCard());
            },
            icon: Icon(Icons.blur_circular),
          ),
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/CardGenerator', arguments: _cardBloc);
            },
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _cardBloc,
      builder: (BuildContext context, CardState state) {
        if (state is CardLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CardLoaded) {
          return GridView.builder(
            gridDelegate: XSliverGridDelegate(
              crossAxisCount: 2,
              smallCellExtent: 120,
              bigCellExtent: 120,
            ),
            itemBuilder: (context, index) {
              final displayedCard = state.barCodeItem[index];
              return Padding(
                  padding: EdgeInsets.all(3),
                  child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Theme.of(context).accentColor,
                      child: InkWell(
                          highlightColor: Colors.lightBlue[300],
                          splashColor: Colors.lightBlue,
                          onTap: () {
                            
                            Navigator.of(context).pushNamed('/CardBarcode',
                                arguments: displayedCard);
                          },
                          onLongPress: () {
                            _deleteDialog(
                                "Действительно хотите удалить карточку?", displayedCard);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              displayedCard.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ))));
            },
            itemCount: state.barCodeItem.length,
          );
        }
      },
    );
  }
}
