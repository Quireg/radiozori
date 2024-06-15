import 'dart:math';

import 'package:flutter/material.dart';

class PlayPausePainter extends CustomPainter {
  late double actualDrawWidth;

  late double centerWidth;
  late double centerHeight;

  double LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_X = 0;
  double LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_Y = 0;

  double LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_X = 0;
  double LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_Y = 0;

  double LEFT_PLAY_RIGHT_TOP_EDGE_X = 0;
  double LEFT_PLAY_RIGHT_TOP_EDGE_Y = 0;

  double LEFT_PLAY_RIGHT_BOTTOM_EDGE_X = 0;
  double LEFT_PLAY_RIGHT_BOTTOM_EDGE_Y = 0;

  double LEFT_PAUSE_RIGHT_TOP_EDGE_X = 0;
  double LEFT_PAUSE_RIGHT_TOP_EDGE_Y = 0;

  double LEFT_PAUSE_RIGHT_BOTTOM_EDGE_X = 0;
  double LEFT_PAUSE_RIGHT_BOTTOM_EDGE_Y = 0;

  double leftRightTopEdgeX = 0;
  double leftRightTopEdgeY = 0;

  double leftRightBottomEdgeX = 0;
  double leftRightBottomEdgeY = 0;

  double RIGHT_PLAY_LEFT_TOP_EDGE_X = 0;
  double RIGHT_PLAY_LEFT_TOP_EDGE_Y = 0;

  double RIGHT_PLAY_RIGHT_TOP_EDGE_X = 0;
  double RIGHT_PLAY_RIGHT_TOP_EDGE_Y = 0;

  double RIGHT_PLAY_RIGHT_BOTTOM_EDGE_X = 0;
  double RIGHT_PLAY_RIGHT_BOTTOM_EDGE_Y = 0;

  double RIGHT_PLAY_LEFT_BOTTOM_EDGE_X = 0;
  double RIGHT_PLAY_LEFT_BOTTOM_EDGE_Y = 0;

  double RIGHT_PAUSE_LEFT_TOP_EDGE_X = 0;
  double RIGHT_PAUSE_LEFT_TOP_EDGE_Y = 0;

  double RIGHT_PAUSE_RIGHT_TOP_EDGE_X = 0;
  double RIGHT_PAUSE_RIGHT_TOP_EDGE_Y = 0;

  double RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_X = 0;
  double RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_Y = 0;

  double RIGHT_PAUSE_LEFT_BOTTOM_EDGE_X = 0;
  double RIGHT_PAUSE_LEFT_BOTTOM_EDGE_Y = 0;

  late double rightLeftTopEdgeX;
  late double rightLeftTopEdgeY;

  late double rightRightTopEdgeX;
  late double rightRightTopEdgeY;

  late double rightRightBottomEdgeX;
  late double rightRightBottomEdgeY;

  late double rightLeftBottomEdgeX;
  late double rightLeftBottomEdgeY;

  final double animationValue;
  BuildContext context;

  PlayPausePainter(this.animationValue, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    actualDrawWidth = min(size.width, size.height);

    centerHeight = size.height / 2;
    centerWidth = size.width / 2;

    LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_X =
        centerWidth - (actualDrawWidth * 50 / 100);
    LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_Y =
        centerHeight - (actualDrawWidth * 50 / 100);

    LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_X =
        centerWidth - (actualDrawWidth * 50 / 100);
    LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_Y =
        centerHeight + (actualDrawWidth * 50 / 100);

    LEFT_PLAY_RIGHT_TOP_EDGE_X = centerWidth;
    LEFT_PLAY_RIGHT_TOP_EDGE_Y = centerHeight - (actualDrawWidth * 25 / 100);

    LEFT_PLAY_RIGHT_BOTTOM_EDGE_X = centerWidth;
    LEFT_PLAY_RIGHT_BOTTOM_EDGE_Y = centerHeight + (actualDrawWidth * 25 / 100);

    LEFT_PAUSE_RIGHT_TOP_EDGE_X = centerWidth - (actualDrawWidth * 15 / 100);
    LEFT_PAUSE_RIGHT_TOP_EDGE_Y = centerHeight - (actualDrawWidth * 50 / 100);

    LEFT_PAUSE_RIGHT_BOTTOM_EDGE_X = centerWidth - (actualDrawWidth * 15 / 100);
    LEFT_PAUSE_RIGHT_BOTTOM_EDGE_Y =
        centerHeight + (actualDrawWidth * 50 / 100);

    leftRightTopEdgeX = LEFT_PLAY_RIGHT_TOP_EDGE_X -
        ((LEFT_PLAY_RIGHT_TOP_EDGE_X - LEFT_PAUSE_RIGHT_TOP_EDGE_X) *
            animationValue);

    leftRightTopEdgeY = LEFT_PLAY_RIGHT_TOP_EDGE_Y -
        ((LEFT_PLAY_RIGHT_TOP_EDGE_Y - LEFT_PAUSE_RIGHT_TOP_EDGE_Y) *
            animationValue);

    leftRightBottomEdgeX = LEFT_PLAY_RIGHT_BOTTOM_EDGE_X -
        ((LEFT_PLAY_RIGHT_BOTTOM_EDGE_X - LEFT_PAUSE_RIGHT_BOTTOM_EDGE_X) *
            animationValue);
    leftRightBottomEdgeY = LEFT_PLAY_RIGHT_BOTTOM_EDGE_Y -
        ((LEFT_PLAY_RIGHT_BOTTOM_EDGE_Y - LEFT_PAUSE_RIGHT_BOTTOM_EDGE_Y) *
            animationValue);

    RIGHT_PAUSE_LEFT_TOP_EDGE_X = centerWidth + (actualDrawWidth * 15 / 100);
    RIGHT_PAUSE_LEFT_TOP_EDGE_Y = centerHeight - (actualDrawWidth * 50 / 100);

    RIGHT_PAUSE_RIGHT_TOP_EDGE_X = centerWidth + (actualDrawWidth * 50 / 100);
    RIGHT_PAUSE_RIGHT_TOP_EDGE_Y = centerHeight - (actualDrawWidth * 50 / 100);

    RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_X =
        centerWidth + (actualDrawWidth * 50 / 100);
    RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_Y =
        centerHeight + (actualDrawWidth * 50 / 100);

    RIGHT_PAUSE_LEFT_BOTTOM_EDGE_X = centerWidth + (actualDrawWidth * 15 / 100);
    RIGHT_PAUSE_LEFT_BOTTOM_EDGE_Y =
        centerHeight + (actualDrawWidth * 50 / 100);

    RIGHT_PLAY_LEFT_TOP_EDGE_X = centerWidth;
    RIGHT_PLAY_LEFT_TOP_EDGE_Y = centerHeight - (actualDrawWidth * 25 / 100);

    RIGHT_PLAY_RIGHT_TOP_EDGE_X = centerWidth + (actualDrawWidth * 50 / 100);
    RIGHT_PLAY_RIGHT_TOP_EDGE_Y = centerHeight;

    RIGHT_PLAY_RIGHT_BOTTOM_EDGE_X = centerWidth + (actualDrawWidth * 50 / 100);
    RIGHT_PLAY_RIGHT_BOTTOM_EDGE_Y = centerHeight;

    RIGHT_PLAY_LEFT_BOTTOM_EDGE_X = centerWidth;
    RIGHT_PLAY_LEFT_BOTTOM_EDGE_Y = centerHeight + (actualDrawWidth * 25 / 100);

    rightLeftTopEdgeX = RIGHT_PLAY_LEFT_TOP_EDGE_X -
        ((RIGHT_PLAY_LEFT_TOP_EDGE_X - RIGHT_PAUSE_LEFT_TOP_EDGE_X) *
            animationValue);
    rightLeftTopEdgeY = RIGHT_PLAY_LEFT_TOP_EDGE_Y -
        ((RIGHT_PLAY_LEFT_TOP_EDGE_Y - RIGHT_PAUSE_LEFT_TOP_EDGE_Y) *
            animationValue);

    rightRightTopEdgeX = RIGHT_PLAY_RIGHT_TOP_EDGE_X -
        ((RIGHT_PLAY_RIGHT_TOP_EDGE_X - RIGHT_PAUSE_RIGHT_TOP_EDGE_X) *
            animationValue);
    rightRightTopEdgeY = RIGHT_PLAY_RIGHT_TOP_EDGE_Y -
        ((RIGHT_PLAY_RIGHT_TOP_EDGE_Y - RIGHT_PAUSE_RIGHT_TOP_EDGE_Y) *
            animationValue);

    rightRightBottomEdgeX = RIGHT_PLAY_RIGHT_BOTTOM_EDGE_X -
        ((RIGHT_PLAY_RIGHT_BOTTOM_EDGE_X - RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_X) *
            animationValue);
    rightRightBottomEdgeY = RIGHT_PLAY_RIGHT_BOTTOM_EDGE_Y -
        ((RIGHT_PLAY_RIGHT_BOTTOM_EDGE_Y - RIGHT_PAUSE_RIGHT_BOTTOM_EDGE_Y) *
            animationValue);

    rightLeftBottomEdgeX = RIGHT_PLAY_LEFT_BOTTOM_EDGE_X -
        ((RIGHT_PLAY_LEFT_BOTTOM_EDGE_X - RIGHT_PAUSE_LEFT_BOTTOM_EDGE_X) *
            animationValue);
    rightLeftBottomEdgeY = RIGHT_PLAY_LEFT_BOTTOM_EDGE_Y -
        ((RIGHT_PLAY_LEFT_BOTTOM_EDGE_Y - RIGHT_PAUSE_LEFT_BOTTOM_EDGE_Y) *
            animationValue);

    var paint = Paint()..color = Theme.of(context).colorScheme.primary;
    var wallPlayLeft = Path();
    var wallPlayRight = Path();

    wallPlayLeft.reset();
    wallPlayLeft.moveTo(LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_X,
        LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_Y);
    wallPlayLeft.lineTo(leftRightTopEdgeX, leftRightTopEdgeY);
    wallPlayLeft.lineTo(leftRightBottomEdgeX, leftRightBottomEdgeY);
    wallPlayLeft.lineTo(LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_X,
        LEFT_PLAY_PAUSE_COMMON_LEFT_BOTTOM_EDGE_Y);
    wallPlayLeft.lineTo(LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_X,
        LEFT_PLAY_PAUSE_COMMON_LEFT_TOP_EDGE_Y);

    wallPlayRight.reset();
    wallPlayRight.moveTo(rightLeftTopEdgeX, rightLeftTopEdgeY);
    wallPlayRight.lineTo(rightRightTopEdgeX, rightRightTopEdgeY);
    wallPlayRight.lineTo(rightRightBottomEdgeX, rightRightBottomEdgeY);
    wallPlayRight.lineTo(rightLeftBottomEdgeX, rightLeftBottomEdgeY);
    wallPlayRight.lineTo(rightLeftTopEdgeX, rightLeftTopEdgeY);

    canvas.drawPath(wallPlayLeft, paint);
    canvas.drawPath(wallPlayRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
