import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_carder/model/barcode_item.dart';

@immutable  
abstract class CardEvent extends Equatable  {
  CardEvent([List props = const []]) :super (props);
}

class LoadCard extends CardEvent {}

class AddRandomCard extends CardEvent {}

class AddScanCard extends CardEvent {
  final BarCodeItem barcodeScanItem;
  AddScanCard(this.barcodeScanItem) : super([barcodeScanItem]);
  
}

class UpdateWithRandomCard extends CardEvent {
  final BarCodeItem updatedCard;

  UpdateWithRandomCard(this.updatedCard) : super([updatedCard]);

}

class DeleteCard extends CardEvent {
  final BarCodeItem barCodeItem;

  DeleteCard(this.barCodeItem) : super([barCodeItem]);
}
