import 'package:sembast/sembast.dart';
import 'package:simple_carder/model/barcode_item.dart';
import 'app_database.dart';

class CardDao {
  static const String CARD_STORE_NAME = 'card';

  final _cardStore = intMapStoreFactory.store(CARD_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(BarCodeItem barCodeItem) async {
    await _cardStore.add(await _db, barCodeItem.toMap());
  }

  Future update(BarCodeItem barCodeItem) async {
    final finder = Finder(filter: Filter.byKey(barCodeItem.id));
    await _cardStore.update(await _db, barCodeItem.toMap(), finder: finder);
  }

  Future delete(BarCodeItem barCodeItem) async {
    final finder = Finder(filter: Filter.byKey(barCodeItem.id));
    await _cardStore.delete(await _db, finder: finder);
  }

  Future<List<BarCodeItem>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [SortOrder('description')]);
    final recordSnapshots = await _cardStore.find(await _db, finder: finder);
    return recordSnapshots.map((snapshot) {
      final barCodeItem = BarCodeItem.fromMap(snapshot.value);
      barCodeItem.id = snapshot.key;
      return barCodeItem;
    }).toList();
  }
}
