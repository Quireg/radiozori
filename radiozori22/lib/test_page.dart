import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:snowfall/snowfall.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: SnowfallWidget(
          color: Theme.of(context).colorScheme.primary,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(padding: const EdgeInsets.all(12),child: SizedBox(
              width: 70,
              height: 30,
              child: TextButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: const Text('Go back'),
              ),
            ),),
          )),
    );
  }
}
