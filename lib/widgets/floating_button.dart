import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';

class CustomFloatingButton extends StatefulWidget {
  final Song song;
  CustomFloatingButton(this.song);
  @override
  CustomFloatingButtonState createState() => CustomFloatingButtonState();
}

class CustomFloatingButtonState extends State<CustomFloatingButton> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(isAdded ? Icons.done : Icons.add),
      onPressed: () {
        Provider.of<SongListP>(context).addSong(widget.song).then((response) {
          setState(() {
            isAdded = true;
          });
        }).catchError((err) {
          print(err);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              actions: [
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
              title: Text("Intellectual Warning!"),
              content: Text(
                "You still have this song or you want to be an orchestra chef",
              ),
            ),
          );
        });
      },
    );
  }
}
