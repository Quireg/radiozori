
import 'package:flutter/material.dart';

import 'player_controls/under_banner.dart';

class LandscapeOrientation extends StatelessWidget {
  const LandscapeOrientation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: Image.asset(
                      'assets/images/top_image_cut.png',
                    ).image)),
          ),
        ),
        const Expanded(
          flex: 5,
          child: UnderBanner(),
        ),
      ],
    );
  }
}
