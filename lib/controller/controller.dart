import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data.dart';

class UserPlaceProvider extends StateNotifier<List<Data>> {
  UserPlaceProvider() : super(const []);

  void addPlace(Data data) {
    state = [data, ...state];
  }

  void missPlace(Data data) {
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
