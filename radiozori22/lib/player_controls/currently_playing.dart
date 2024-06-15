import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_radio_player/models/frp_player_event.dart';

import '../flutter_radio_player_plugin.dart';

class CurrentlyPlaying extends StatefulWidget {
  CurrentlyPlaying({Key? key}) : super(key: key);

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
  final flutterRadioPlayer = Modular.get<FlutterRadioPlayer>();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  String currentPlaying = "";
  String latestPlaybackStatus = "flutter_radio_stopped";

  @override
  void initState() {
    super.initState();
    widget.flutterRadioPlayer.requestUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.flutterRadioPlayer.frpEventStream!,
      builder: (context, snapshot) {
        try {
          if (kDebugMode) {
            print("CPPPPPP FRPEvent ${jsonDecode(snapshot.data as String)}");
          }

          FRPPlayerEvents frpEvent =
              FRPPlayerEvents.fromJson(jsonDecode(snapshot.data as String));
          if (frpEvent.icyMetaDetails != null) {
            currentPlaying = frpEvent.icyMetaDetails!;
          }
          if (frpEvent.playbackStatus != null) {
            latestPlaybackStatus = frpEvent.playbackStatus!;
          }
          if (latestPlaybackStatus == "flutter_radio_paused" ||
              latestPlaybackStatus == "flutter_radio_stopped") {
            resetNowPlayingInfo();
          }
        } catch (e) {
          if (kDebugMode) {
            print("CPPPPPP jsonDecode(snapshot.data as String) IS NOT JSON $e");
          }
        }

        return GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: currentPlaying));
          },
          child: Text(
            currentPlaying,
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.primary),
          ),
        );
      },
    );
  }

  void resetNowPlayingInfo() {
    currentPlaying = "";
  }
}
