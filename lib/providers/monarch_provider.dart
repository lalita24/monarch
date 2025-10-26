import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../models/monarch.dart';

class MonarchProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Monarch> _items = [];
  List<Monarch> get items => _items;

  Future<void> load() async {
    _items = await _db.getAllMonarchs();
    notifyListeners();
  }

  Future<void> add(Monarch m) async {
    final id = await _db.insertMonarch(m);
    _items.add(m.copyWith(id: id));
    _items.sort((a, b) => a.reignNo.compareTo(b.reignNo));
    notifyListeners();
  }

  Future<void> update(Monarch m) async {
    final rows = await _db.updateMonarch(m);
    if (rows > 0) {
      final i = _items.indexWhere((e) => e.id == m.id);
      if (i != -1) {
        _items[i] = m;
        _items.sort((a, b) => a.reignNo.compareTo(b.reignNo));
        notifyListeners();
      }
    }
  }

  Future<void> remove(int id) async {
    final rows = await _db.deleteMonarch(id);
    if (rows > 0) {
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }
}
