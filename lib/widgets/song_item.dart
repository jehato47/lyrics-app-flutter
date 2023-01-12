import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';
import '../screens/add_song_screen.dart';
import '../screens/song_detail_screen.dart';

class SongItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final song = Provider.of<Song>(context, listen: false);
    return Consumer<Song>(
      builder: (context, song, child) => Dismissible(
        direction: DismissDirection.startToEnd,
        key: Key((song.id as String)),
        onDismissed: (w) async {
          await Provider.of<SongListP>(context, listen: false).removeItem(song);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            color: Colors.black54,
            elevation: 4,
            child: ListTile(
              onLongPress: () {
                Navigator.of(context).pushNamed(
                  AddSongScreen.url,
                  arguments: song,
                );
              },
              onTap: () {
                Navigator.of(context).pushNamed(
                  SongDetailScreen.url,
                  arguments: song,
                );
              },
              trailing: Icon(
                Icons.music_note_rounded,
                color: Colors.white38,
              ),
              leading: Text(
                "${song.name!.substring(0, song.name!.length >= 25 ? 25 : song.name!.length)}"
                "${song.name!.length >= 25 ? '..' : ''}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
