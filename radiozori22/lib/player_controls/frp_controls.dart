import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_radio_player/models/frp_player_event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../flutter_radio_player_plugin.dart';
import 'play_pause_painter.dart';

class FRPPlayerControls extends StatefulWidget {
  final flutterRadioPlayer = Modular.get<FlutterRadioPlayer>();

  FRPPlayerControls({
    Key? key,
  }) : super(key: key);

  @override
  State<FRPPlayerControls> createState() => _FRPPlayerControlsState();
}

class _FRPPlayerControlsState extends State<FRPPlayerControls>
    with TickerProviderStateMixin {
  String latestPlaybackStatus = "flutter_radio_stopped";
  bool isFirstValue = true;

  VoidCallback listener() => () {
    setState(() {});
  };

  late AnimationController controller;


  @override
  void initState() {
    super.initState();
    // widget.flutterRadioPlayer.setVolume(1.0);
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,//pause state - play drawn
      upperBound: 1.0, //play state - pause drawn
      duration: const Duration(milliseconds: 300),
    );
    widget.flutterRadioPlayer.requestUpdate();

    controller.addListener(listener());
    // controller.stop();
    // controller.reverse();
  }

  Widget getPlayPause(double animValue) {
    return GestureDetector(
      child: CustomPaint(
        painter: PlayPausePainter(animValue, context),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      onTap: () {
        setState(() {
          widget.flutterRadioPlayer.playOrPause();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.flutterRadioPlayer.frpEventStream!,
        builder: (context, snapshot) {
          double animValue = 1.0;

          try {
            FRPPlayerEvents frpEvent =
                FRPPlayerEvents.fromJson(jsonDecode(snapshot.data as String));

            if (isFirstValue) {
              if (kDebugMode) print("$this isFirstValue $isFirstValue");
            } else {
              animValue = controller.value;
            }

            if (frpEvent.playbackStatus != null) {
              if (latestPlaybackStatus != frpEvent.playbackStatus! ||
                  isFirstValue) {

                if (kDebugMode) {
                  print("$this FRPEvent ${jsonDecode(snapshot.data as String)}");
                }
                if (frpEvent.playbackStatus == "flutter_radio_playing") {
                  if (isFirstValue) {
                    animValue = 1.0;
                  } else {
                    controller.stop();
                    controller.forward();
                  }
                } else if (frpEvent.playbackStatus == "flutter_radio_paused") {
                  if (isFirstValue) {
                    animValue = 0.0;
                  } else {
                    controller.stop();
                    controller.reverse();
                  }
                } else if (frpEvent.playbackStatus == "flutter_radio_stopped") {
                  SystemNavigator.pop();
                }
                latestPlaybackStatus = frpEvent.playbackStatus!;
              }
            }
            if (isFirstValue) {
              WidgetsBinding.instance.addPostFrameCallback((_){
                controller.value = animValue;
              });
                isFirstValue = false;
            }
            return getPlayPause(animValue);
          } catch (e) {
            return SpinKitRotatingCircle(
              color: Theme.of(context).colorScheme.primary,
              size: 50.0,
            );
          }
        });
  }
}
