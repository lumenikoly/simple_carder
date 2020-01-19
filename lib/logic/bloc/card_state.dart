import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:simple_carder/model/barcode_item.dart';

@immutable
abstract class CardState extends Equatable {
  CardState([List props = const []]) : super(props);
}

class CardLoading extends CardState {}

class CardLoaded extends CardState {
  final List<BarCodeItem> barCodeItem;
  CardLoaded(this.barCodeItem) : super([barCodeItem]);
}
