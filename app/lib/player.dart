import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:bunker/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

class PagePlayer extends StatefulWidget {
  const PagePlayer({Key? key}) : super(key: key);

  @override
  State<PagePlayer> createState() => _PagePlayerState();
}

class _PagePlayerState extends State<PagePlayer> {
  var player = Player.asset(BunkerStorage.event.audio, autoPlay: true);

  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    if (player.duration.inSeconds < 1) return;
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: player.duration.inSeconds),
        curve: Curves.linear);
  }

  late Future<String> text;

  @override
  void initState() {
    super.initState();

    text = DefaultAssetBundle.of(context)
        .loadString('assets/text/${BunkerStorage.event.id}.txt');
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
    if (Platform.isLinux) {
      try {
        player.dispose();
      } catch (err) {
        // pass
      }
    }
  }

  bool _changingPosition = false;
  bool loading = false;
  Duration _position = Duration.zero;
  double get position {
    if (player.duration.inSeconds == 0) {
      return 0;
    }
    if (_changingPosition) {
      return _position.inSeconds * 100 / player.duration.inSeconds;
    } else {
      return player.position.inSeconds * 100 / player.duration.inSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.65;
    if (Platform.isAndroid) {
      width = MediaQuery.of(context).size.width * 0.9;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text(BunkerStorage.event.title),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: StreamBuilder(
                      stream: player.streams.status,
                      builder: (context, AsyncSnapshot<PlayerStatus> snapshot) {
                        return CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.amber,
                          value: loading
                              ? null
                              : player.position.inSeconds /
                                  max(player.duration.inSeconds, 0.01),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: FloatingActionButton(
                      disabledElevation: 0,
                      elevation: 0,
                      focusElevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      onPressed: () {
                        player.toggle();
                      },
                      child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.black87),
                        child: StreamBuilder(
                          stream: player.streams.playing,
                          builder: (context, snapshot) {
                            return player.playing
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.black,
                                    size: 80,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                    size: 80,
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  child: StreamBuilder(
                      stream: player.streams.position,
                      builder: (context, snapshot) {
                        var durMin = player.duration.inMinutes % 60;
                        var durMinStr = durMin.toString();
                        if (durMin < 10) {
                          durMinStr = '0' + durMinStr;
                        }
                        var durSec = player.duration.inSeconds % 60;
                        var durSecStr = durSec.toString();
                        if (durSec < 10) {
                          durSecStr = '0' + durSecStr;
                        }

                        var posMin = player.position.inMinutes % 60;
                        var posMinStr = posMin.toString();
                        if (posMin < 10) {
                          posMinStr = '0' + posMinStr;
                        }
                        var posSec = player.position.inSeconds % 60;
                        var posSecStr = posSec.toString();
                        if (posSec < 10) {
                          posSecStr = '0' + posSecStr;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${posMinStr}:${posSecStr}"),
                            Text("${durMinStr}:${durSecStr}"),
                          ],
                        );
                      }),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: width,
                child: StreamBuilder(
                    stream: player.streams.position,
                    builder: (context, AsyncSnapshot<Duration> snapshot) {
                      loading = false;
                      return Slider(
                        value: position,
                        min: 0,
                        activeColor: Colors.amber,
                        inactiveColor: Colors.amber.shade100,
                        max: 100,
                        onChangeStart: (double value) {
                          _changingPosition = true;
                        },
                        onChangeEnd: (double value) {
                          _changingPosition = false;
                        },
                        onChanged: (double value) {
                          loading = true;
                          _position = Duration(
                              seconds:
                                  ((value / 100) * player.duration.inSeconds)
                                      .toInt());
                          player.position = _position;
                        },
                      );
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: width,
                child: Row(
                  children: [
                    const Icon(
                      Icons.volume_up,
                      size: 32.0,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: player.streams.volume,
                        builder: (context, AsyncSnapshot<double> snapshot) {
                          return Slider(
                            activeColor: Colors.amber,
                            inactiveColor: Colors.amber.shade100,
                            value: player.volume * 100,
                            min: 0,
                            max: 100,
                            // label: player.volume.round().toString(),
                            onChanged: (double value) {
                              player.volume = value / 100;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // height: 200.0,
                  margin: const EdgeInsets.symmetric(vertical: 40.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20.0),
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 2.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: FutureBuilder<String>(
                      future: text,
                      builder:
                          (BuildContext context, AsyncSnapshot<String> txt) {
                        if (txt.hasData) {
                          Timer(Duration(seconds: 1), () {
                            _scrollToBottom();
                          });
                          return Text(
                            txt.data ?? 'Описание не найдено',
                            maxLines: 1000,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              fontFamily: 'monospace',
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: ,
    );
  }
}
