import 'package:flutter/material.dart';
import '../providers/song.dart';

class SongDetailScreen extends StatelessWidget {
  static const url = "/song-detail";

  @override
  Widget build(BuildContext context) {
    final song = ModalRoute.of(context).settings.arguments as Song;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/mic.jpeg"),
          colorFilter: ColorFilter.mode(
            Colors.blueGrey,
            BlendMode.modulate,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text("${song.name} - ${song.artist}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    song.lyrics,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
