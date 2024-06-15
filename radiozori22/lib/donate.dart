import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowfall/snowfall.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screen/size_extension.dart';
import 'themes/colors.dart';
import 'themes/text_style.dart';

class Donate extends StatelessWidget {
  const Donate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getSnowflakesOrNot(context);
  }

  Widget getSnowflakesOrNot(BuildContext context) {
    DateTime now = DateTime.now();
    if (now.month == 12 || now.month == 1 || now.month == 2 || false) {
      return Container(
        color: AppColors.background,
        child: SnowfallWidget(
            child: getScene(context),
            color: Colors.amberAccent,
            numberOfSnowflakes: 50),
      );
    } else {
      return getScene(context);
    }
  }

  Widget getScene(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.h),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontFamily: 'MazzardH',
                      fontSize: 24.ssp,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'ДОПОМОГА ПРОЕКТУ',
                      style: textHeading,
                    ),
                  ],
                )),
          ),
          Container(
              child: Row(
            children: [
              SizedBox(width: 16.w),
              Expanded(
                  child: Column(
                children: [
                  RichText(
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'MazzardH',
                          fontSize: 16.ssp,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Радіо існує завдяки вашій підтримці\n',
                            style: textHeading,
                          ),
                          TextSpan(
                            text:
                                'Це не комерційний проект, і не належить жодному '
                                'олігарху. Якби кожен наш слухач перераховував '
                                'щомісяця хоча б по 10 гривень, ми змогли б почути '
                                'українську музику навіть на північному полюсі!',
                            style: textNormal,
                          ),
                        ],
                      )),
                ],
              )),
              SizedBox(width: 16.w),
              Align(
                child: GestureDetector(child: Image.asset(
                  'assets/images/donate.png',
                  width: 75.w,
                  height: 75.w,
                ), onTap: () {
                  openPatreon();
                },)
              ),
              SizedBox(width: 16.w),
            ],
          )),
          SizedBox(height: 16.h),
          Row(
            children: [
              SizedBox(width: 16.w),
              Expanded(
                  child: Column(
                children: [
                  RichText(
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'MazzardH',
                          fontSize: 16.ssp,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Налаштуй щомісячний платіж\n',
                            style: textHeading,
                          ),
                          TextSpan(
                            text: "• pb.ua: ",
                            children: [
                              TextSpan(
                                text: "5168 7554 3806 3444",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        Clipboard.setData(ClipboardData(
                                            text: "5168755438063444")),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text('Скопійовано!')))
                                      },
                              ),
                              TextSpan(text: "\n")
                            ],
                            style: textNormal,
                          ),
                          TextSpan(
                            text: "• monobank: ",
                            children: [
                              TextSpan(
                                text: "4441 1144 0176 3873",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        Clipboard.setData(ClipboardData(
                                            text: "4441114401763873")),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text('Скопійовано!')))
                                      },
                              ),
                              TextSpan(text: " - UAH \n")
                            ],
                            style: textNormal,
                          ),
                          TextSpan(
                            text: "• monobank: ",
                            children: [
                              TextSpan(
                                text: "5375 4188 1019 0363",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {
                                        Clipboard.setData(ClipboardData(
                                            text: "5375418810190363")),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text('Скопійовано!')))
                                      },
                              ),
                              TextSpan(text: " - USD\n")
                            ],
                            style: textNormal,
                          ),
                          TextSpan(
                            text: "• patreon - ",
                            children: [
                              TextSpan(
                                text: "https://www.patreon.com/radiozori",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => openPatreon(),
                              ),
                              TextSpan(text: "\n")
                            ],
                            style: textNormal,
                          ),
                        ],
                      )),
                ],
              )),
              SizedBox(width: 16.w),
            ],
          ),
          SizedBox(height: 18.h),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                    fontFamily: 'MazzardH',
                    fontSize: 24.ssp,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'ХОЧЕМО БУТИ КРАЩЕ РАЗОМ',
                    style: textNormal,
                  ),
                ],
              )),
          RichText(
              textAlign: TextAlign.justify,
              softWrap: true,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'MazzardH',
                  fontSize: 16.ssp,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: 'Пишіть та приймайте участь у дискусіях!\n',
                    style: textNormal,
                  ),
                  TextSpan(
                    text: 'https://www.facebook.com/groups/radiozori/',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openFacebookDiscussion(),
                    style: textNormal,
                  ),
                ],
              )),
        ],
      ),
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
