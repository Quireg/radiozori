import 'package:flutter/material.dart';

import 'player_controls/under_banner.dart';

class PortraitOrientation extends StatelessWidget {
  const PortraitOrientation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      image: Image.asset(
                        'assets/images/top_image.png',
                      ).image)),
            )),
        const Expanded(
          flex: 7,
          child: UnderBanner(),
        ),
      ],
    );

    return Column(
      children: [
        Expanded(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      image: Image.asset(
                        'assets/images/top_image.png',
                      ).image)),
            ),
            flex: 4),
        const Expanded(
          child: UnderBanner(),
          flex: 6,
        ),
      ],
    );
  }
}
