import 'dart:async';
import 'dart:math';

import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:simple_carder/database/card_dao.dart';
import 'package:simple_carder/logic/bloc/card_state.dart';
import 'package:simple_carder/model/barcode_item.dart';
import 'card_event.dart';


class CardBloc extends Bloc<CardEvent, CardState> {
   CardDao _cardDao = CardDao();
  @override
  CardState get initialState => CardLoading();

  @override
  Stream<CardState> mapEventToState(CardEvent event) async* {
    if (event is LoadCard) {
      yield CardLoading();
      yield* _reloadCard();
    } else if (event is AddRandomCard) {
      await _cardDao.insert(RandomCardGenerator.getRandomCard());
      yield* _reloadCard();
    } else if (event is UpdateWithRandomCard) {
      final newCard = RandomCardGenerator.getRandomCard();
      newCard.id = event.updatedCard.id;
      await _cardDao.update(newCard);
      yield* _reloadCard();
    } else if (event is DeleteCard) {
      await _cardDao.delete(event.barCodeItem);
      yield* _reloadCard();
    } else if (event is AddScanCard) {
      await _cardDao.insert(ScanerCardGenerator(event.barcodeScanItem).getScanerCardGenerator());
      yield* _reloadCard();
    } 
  }

  Stream<CardState> _reloadCard() async* {
    final card = await _cardDao.getAllSortedByName();
    yield CardLoaded(card);
  }


}


class ScanerCardGenerator {
  final BarCodeItem _barCodeItem;

  ScanerCardGenerator(this._barCodeItem);

   BarCodeItem getScanerCardGenerator() {
      return _barCodeItem;
  }

}

class RandomCardGenerator {
  static final _cards = [
    BarCodeItem(
        type: BarCodeType.CodeEAN13,
        codeStr: "0001211380000",
        description: "Случайная карта",
        hasText: true),
    BarCodeItem(
        type: BarCodeType.CodeEAN13,
        codeStr: "0001532110000",
        description: "Карта",
        hasText: true),
    BarCodeItem(
        type: BarCodeType.CodeEAN13,
        codeStr: "0001158190000",
        description: "Большое длинное название",
        hasText: true),
  ];
  static BarCodeItem getRandomCard() {
    return _cards[Random().nextInt(_cards.length)];
  }
}
