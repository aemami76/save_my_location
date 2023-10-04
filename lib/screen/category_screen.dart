import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:save_my_locations/controller/controller.dart';
import 'package:save_my_locations/data/data.dart';
import 'package:save_my_locations/screen/add_screen.dart';
import 'package:save_my_locations/screen/detail_screen.dart';

class Category extends ConsumerWidget {
  const Category({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataList = ref.watch(preData) as List<Data>;

    ref.read(preData.notifier).loadPlace();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        actions: [
          ref.watch(mySeed.notifier).colorChanger(),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Add()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: dataList.isEmpty
          ? const Center(
              child: Text("No place to show."),
            )
          : Column(
              children: [
                ...dataList
                    .map((pd) => Dismissible(
                          onDismissed: (dir) {
                            ref.read(preData.notifier).missPlace(pd);
                          },
                          key: Key(pd.id),
                          background: Container(
                            color: Colors.redAccent,
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  File(pd.imagePath),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detail(pd),
                                  ),
                                );
                              },
                              title: Text(
                                pd.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(pd.address!,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
    );
  }
}
