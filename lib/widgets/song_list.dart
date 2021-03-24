import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';
import '../widgets/song_item.dart';

class SongList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider.of<SongListP>(context, listen: false).fetchAndSetSongs();
    final List<Song> songs =
        Provider.of<SongListP>(context, listen: false).songs;
    if (songs.isEmpty) {
      print("evet");
    }
    return ListView.builder(
      // shrinkWrap: true,
      itemCount: songs.length,
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: songs[i],
          child: SongItem(),
        );
      },
    );
  }
}
