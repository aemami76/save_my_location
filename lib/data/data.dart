import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Data {
  Data(
      {required this.title,
      required this.imagePath,
      required this.address,
      required this.addressPic,
      String? id})
      : id = id ?? uuid.v4();
  final String title;
  final String id;
  final String imagePath;
  final String? address;
  final String? addressPic;
}
