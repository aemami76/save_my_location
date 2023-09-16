import 'dart:io';

import 'package:flutter/material.dart';

import '../data/data.dart';

class Detail extends StatelessWidget {
  const Detail(this.data, {super.key});
  final Data data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 300,
            left: 0,
            child: Image.file(
              File(data.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              color: Theme.of(context).cardColor,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                        child: CircleAvatar(
                      maxRadius: 500,
                      child: ClipOval(
                        child: Image.file(
                          File(data.addressPic!),
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Text(
                        data.address!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
