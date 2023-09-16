import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_my_locations/controller/controller.dart';
import 'package:save_my_locations/widget/get_image.dart';
import 'package:save_my_locations/widget/get_location.dart';

class Add extends ConsumerWidget {
  Add({Key? key}) : super(key: key);

  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(newData);
    ref.refresh(gettingLocation);

    void addScreen() {
      final title = _titleController.text;
      ref.read(newData.notifier).dataTitle = title;

      if (ref.watch(newData.notifier).addScreen(context) == null) return;
      ref
          .read(preData.notifier)
          .addPlace(ref.watch(newData.notifier).addScreen(context)!);

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Your Favorite Place."),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'title',
                suffixIcon: Icon(Icons.home),
              ),
              maxLength: 50,
              controller: _titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            const GetImage(),
            const SizedBox(
              height: 20,
            ),
            const GetLocation(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("CANCEL"),
                  icon: const Icon(Icons.cancel_outlined),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: addScreen,
                  label: const Text("SAVE"),
                  icon: const Icon(Icons.save_alt),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
