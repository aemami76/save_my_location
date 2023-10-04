import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as pat;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../data/data.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(pat.join(dbPath, 'myPlaces.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, imagePath TEXT, address TEXT, addressPic TEXT)');
  }, version: 1);
  return db;
}

class UserPlaceProvider extends StateNotifier<List<Data>> {
  UserPlaceProvider() : super(const []);

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map((row) => Data(
            id: row['id'] as String,
            title: row['title'] as String,
            imagePath: row['imagePath'] as String,
            address: row['address'] as String,
            addressPic: row['addressPic'] as String))
        .toList();
    state = places;
  }

  void addPlace(Data data) async {
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': data.id,
      'title': data.title,
      'imagePath': data.imagePath,
      'address': data.address,
      'addressPic': data.addressPic,
    });

    state = [data, ...state];
  }

  void missPlace(Data data) async {
    final db = await _getDatabase();
    await db.rawDelete(
      'DELETE FROM user_places WHERE id = ?',
      [data.id],
    );
    final index = !state.contains(data);
    state.remove(data);
  }
}

final preData = StateNotifierProvider((ref) => UserPlaceProvider());

//------------------------------------------------------------------------------------------

class newDataProvider extends StateNotifier<Data> {
  newDataProvider()
      : super(Data(title: '', imagePath: '', address: null, addressPic: null));

  set dataTitle(String value) {
    state = Data(
        title: value,
        imagePath: state.imagePath,
        address: state.address,
        addressPic: state.addressPic);
  }

  set dataImage(String value) {
    state = Data(
        title: state.title,
        imagePath: value,
        address: state.address,
        addressPic: state.addressPic);
  }

  set getAddress(String? value) {
    state = Data(
        title: state.title,
        imagePath: state.imagePath,
        address: value,
        addressPic: state.addressPic);
  }

  set getAddressPic(String? value) {
    state = Data(
        title: state.title,
        imagePath: state.imagePath,
        address: state.address,
        addressPic: value);
  }

  Data? addScreen(BuildContext context) {
    if (state.title == '' ||
        state.imagePath == '' ||
        state.address == null ||
        state.addressPic == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Complete All Parts")));
    } else {
      return state;
    }
  }
}

final newData =
    StateNotifierProvider<newDataProvider, Data>((ref) => newDataProvider());

final gettingLocation = StateProvider<bool>((ref) => false);
//------------------------------------------------------------------------------------------

class mySeedNotifier extends StateNotifier<ThemeData> {
  mySeedNotifier() : super(ThemeData.light());

  Widget colorChanger() {
    return IconButton(
        onPressed: () {
          _changeColor();
        },
        icon: Icon(Icons.color_lens_sharp));
  }

  void _changeColor() {
    state == ThemeData.light()
        ? state = ThemeData.dark()
        : state = ThemeData.light();
  }
}

final mySeed =
    StateNotifierProvider<mySeedNotifier, ThemeData>((ref) => mySeedNotifier());
