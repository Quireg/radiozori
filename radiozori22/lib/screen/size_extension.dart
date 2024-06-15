import 'screenutil.dart';

extension SizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtil().setHeight(this);

  ///[ScreenUtil.setSp]
  double get sp => ScreenUtil().setSp(this);

  ///[ScreenUtil.setSp]
  double get ssp => ScreenUtil().setSp(this, allowFontScalingSelf: true);

  ///[ScreenUtil.setSp]
  double get nsp => ScreenUtil().setSp(this, allowFontScalingSelf: false);

  ///Multiple of screen width
  num get wp => ScreenUtil.screenWidth * this;

  ///Multiple of screen height
  num get hp => ScreenUtil.screenHeight * this;
}
