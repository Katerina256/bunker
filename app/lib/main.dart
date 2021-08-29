import 'dart:io';

import 'package:animations/animations.dart';
import 'package:bunker/player.dart';
import 'package:bunker/qr.dart';
import 'package:bunker/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';

import 'data.dart';

void main() {
  Player.boot();
  runApp(BunkerApp());
}

class BunkerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Бункер',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        accentColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
      ),
      home: PageHome(),
    );
  }
}

class PageHome extends StatelessWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
      appBar: AppBar(title: Text('Бункер')),
      body: Center(
          child: ListView(
        children: BunkerData.eList.map((e) {
          var event = BunkerData.eData[e]!;

          return OpenContainer(
            transitionType: ContainerTransitionType.fade,
            openBuilder: (BuildContext _, VoidCallback openContainer) {
              return const PagePlayer();
            },
            tappable: false,
            closedShape: const RoundedRectangleBorder(),
            closedElevation: 0.0,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return ListTile(
                tileColor: Theme.of(context).accentColor.withOpacity(0.6),
                // leading: Image.asset(
                //   'assets/avatar_logo.png',
                //   width: 40,
                // ),
                onTap: () {
                  BunkerStorage.event = event;
                  openContainer();
                },
                title: Text(
                  event.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: Text(event.duration),
              );
            },
          );
        }).toList(),
      )),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.qr_code_scanner,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PageQR()));
              },
            )
          : null,
    );
  }
}
