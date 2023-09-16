import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_my_locations/controller/controller.dart';

class GetImage extends ConsumerWidget {
  const GetImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    File? selectedImage = File(ref.watch(newData).imagePath);
    String path = ref.watch(newData).imagePath;

    void takePicture() async {
      final ImagePicker picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: ImageSource.camera, maxHeight: 300);
      if (pickedImage == null) {
        return;
      }
      ref.read(newData.notifier).dataImage = pickedImage.path;
    }

    void selectPicture() async {
      final ImagePicker picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: ImageSource.gallery, maxHeight: 600);
      if (pickedImage == null) {
        return;
      }
      ref.read(newData.notifier).dataImage = pickedImage.path;
    }

    Widget content() {
      if (path == '') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                onPressed: takePicture,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Picture.')),
            ElevatedButton.icon(
                onPressed: selectPicture,
                icon: const Icon(Icons.picture_in_picture_alt_rounded),
                label: const Text('Select Picture.')),
          ],
        );
      } else {
        return Stack(
          children: [
            Image.file(
              selectedImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: takePicture,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Picture.')),
                    ElevatedButton.icon(
                        onPressed: selectPicture,
                        icon: const Icon(Icons.picture_in_picture_alt_rounded),
                        label: const Text('Select Picture.')),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 20,
          child: Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            child: content(),
          ),
        ));
  }
}
