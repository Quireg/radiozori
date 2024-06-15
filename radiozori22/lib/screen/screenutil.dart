import 'package:flutter/widgets.dart';

class ScreenUtil {
  static ScreenUtil? _instance;
  static const int _defaultWidth = 1080;
  static const int _defaultHeight = 1920;

  /// Size of the phone in UI Design , px
  num _uiWidthPx = 0;
  num _uiHeightPx = 0;

  /// allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  bool _allowFontScaling = false;

  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _pixelRatio = 0;
  static double _statusBarHeight = 0;
  static double _bottomBarHeight = 0;
  static double _textScaleFactor = 0;

  ScreenUtil._();

  factory ScreenUtil() {
    if (_instance != null) {
      return _instance!;
    } else {
      throw Error();
    }
  }

  static void init({
    required BuildContext context,
    num width = _defaultWidth,
    num height = _defaultHeight,
    bool allowFontScaling = false,
  }) {
    _instance ??= ScreenUtil._();
    var window = MediaQuery.of(context);
    _instance?._uiWidthPx = width;
    _instance?._uiHeightPx = height;
    _instance?._allowFontScaling = allowFontScaling;
    _pixelRatio = window.devicePixelRatio;
    _screenWidth = window.size.width;
    _screenHeight = window.size.height;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _textScaleFactor = window.textScaleFactor;
  }

  /// The number of font pixels for each logical pixel.
  static double get textScaleFactor => _textScaleFactor;

  /// The size of the media in logical pixels (e.g, the size of the screen).
  static double get pixelRatio => _pixelRatio;

  /// The horizontal extent of this size.
  static double get screenWidth => _screenWidth / _pixelRatio;

  ///The vertical extent of this size. dp
  static double get screenHeight => _screenHeight / _pixelRatio;

  /// The vertical extent of this size. px
  static double get screenWidthPx => _screenWidth;

  /// The vertical extent of this size. px
  static double get screenHeightPx => _screenHeight;

  /// The offset from the top
  static double get statusBarHeight => _statusBarHeight / _pixelRatio;

  /// The offset from the top
  static double get statusBarHeightPx => _statusBarHeight;

  /// The offset from the bottom.
  static double get bottomBarHeight => _bottomBarHeight;

  /// The ratio of the actual dp to the design draft px
  double get scaleWidth => _screenWidth / _uiWidthPx;

  double get scaleHeight => _screenHeight / _uiHeightPx;

  double get scaleText => scaleWidth;

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  double setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => height * scaleHeight;

  ///Font size adaptation method
  ///@param [fontSize] The size of the font on the UI design, in px.
  ///@param [allowFontScaling]
  double setSp(num fontSize, {bool? allowFontScalingSelf}) => allowFontScalingSelf == null
      ? (_allowFontScaling ? (fontSize * scaleText) : ((fontSize * scaleText) / _textScaleFactor))
      : (allowFontScalingSelf ? (fontSize * scaleText) : ((fontSize * scaleText) / _textScaleFactor));
}
