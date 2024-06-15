import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Radiozori/screen/size_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import 'themes/colors.dart';
import 'themes/text_style.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                        image: Image.asset(
                          'assets/images/top_image_2.png',
                        ).image)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'internet-radio Української  музики створено волонтерами та ентузіастами.'
                          '\n Поширення та підтримка вітається!\n Будь кращим, долучайся!',
                      style: textHeading,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h, left: 16.w, right: 16.w),
                child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text:
                          'Це не комерційний проєкт, сучасної української музики.\n',
                      style: textHeading,
                      children: [
                        TextSpan(
                          text: 'В наших планах робити трансляції по всьому світові'
                              '. Мріємо про музичний фестиваль ♡.\n',
                          style: textHeading,
                        ),
                        TextSpan(
                          text: 'Ідея виникла з бажання слухати та поширювати класну сучасну українську музику.\n',
                          style: textHeading,
                        )
                      ]
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 16.w, right: 16.w),
                child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'https://t.me/Radiozori_radio\n',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => openTG(),
                      style: textHeading,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'https://www.facebook.com/Radiozori.ua\n',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openFB1(),
                    style: textHeading,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'https://www.facebook.com/groups/radiozori\n',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openFB2(),
                    style: textHeading,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'https://quireg.github.io\n',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openQ(),
                    style: textHeading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openTG() async {
    final Uri url = Uri.parse('https://t.me/Radiozori_radio');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  openFB1() async {
    final Uri url = Uri.parse('https://www.facebook.com/Radiozori.ua');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  openFB2() async {
    final Uri url = Uri.parse('https://www.facebook.com/groups/radiozori');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  openQ() async {
    final Uri url = Uri.parse('https://quireg.github.io');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
