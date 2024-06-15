import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowfall/snowfall.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'screen/size_extension.dart';
import 'themes/colors.dart';
import 'themes/text_style.dart';

class Msvit extends StatefulWidget {
  const Msvit({Key? key}) : super(key: key);

  @override
  State<Msvit> createState() => _MsvitState();
}

class _MsvitState extends State<Msvit> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '9Q3Oh-j13js',
    flags: const YoutubePlayerFlags(
        autoPlay: true, mute: true, hideControls: true, loop: true),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: AppColors.background,
        child: getScene(context),
      ),
    );
  }

  Widget getYouTubeVideo() {
    return GestureDetector(
      child: YoutubePlayer(
          controller: _controller, showVideoProgressIndicator: true),
      onTap: () {
        openYoutube();
      },
    );
  }

  openYoutube() async {
    final Uri url = Uri.parse('https://youtu.be/9Q3Oh-j13js');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget getScene(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'YOUTUBE КАНАЛ - M SVIT\n',
                style: textHeading,
                children: [
                  TextSpan(
                    text:
                        'Підписуйтесь і слідкуйте за останніми подіями української музичної сцени.',
                    style: textNormal,
                  )
                ],
              )),
        ),
        Padding(padding: EdgeInsets.only(top: 18.h), child: getYouTubeVideo()),
      ]),
    );
  }

  openPatreon() async {
    final Uri url = Uri.parse('https://www.patreon.com/radiozori');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  openFacebookDiscussion() async {
    final Uri url = Uri.parse('https://www.facebook.com/groups/radiozori/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
