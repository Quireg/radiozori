import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'currently_playing.dart';
import 'frp_controls.dart';

class UnderBanner extends StatelessWidget {
  const UnderBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: CurrentlyPlaying(),
              ),
            ),
            Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: FRPPlayerControls(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Container()/*Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Modular.to.pushNamed('/donate');
                    },
                    child: const Text("Donate"),
                  )*/,
                )
          ],
        ),
      ],
    );
  }
}
