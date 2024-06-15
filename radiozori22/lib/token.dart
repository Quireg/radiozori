import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Radiozori/screen/size_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import 'themes/colors.dart';
import 'themes/text_style.dart';

class Token extends StatelessWidget {
  const Token({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'У нас є свій токен! \n',
                      style: textHeading
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Усі, хто надав допомогу "Radiozori" \n'
                          ' internet-radio отримають токени "RMIX"',
                      style: textHeading,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Переходьте за посиланням щоб дізнатися більше!\n',
                      style: textHeading,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'https://radiozori.wixsite.com/radio/tokenrmix',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openTokenInfoLink(),
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

  openTokenInfoLink() async {
    final Uri url = Uri.parse('https://radiozori.wixsite.com/radio/tokenrmix');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
