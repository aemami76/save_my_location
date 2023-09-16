import 'package:flutter/material.dart';
class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network('https://www.mapquestapi.com/staticmap/v5/map?key=unFc92NLc7UDEzgpKYtI5qGzf063YjKj&center=37.4219983,-122.084,MA&size=170,170@2x');
  }
}
