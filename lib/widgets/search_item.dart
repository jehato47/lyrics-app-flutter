import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/searched_detail_screen.dart';
import '../providers/search.dart';
import '../providers/song.dart';

class SearchItem extends StatefulWidget {
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Search>(context, listen: false);
    Song song;
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        setState(() {
          isLoading = true;
        });

        try {
          song = await Provider.of<SearchProvider>(context).parseLyrics(
            item.title + " " + item.artistName,
          );
          bool isAdded = Provider.of<SongListP>(context).isAdded(song);
          song.name = item.title;
          Navigator.of(context).pushNamed(
            SearchedDetailScreen.url,
            arguments: {
              "lyrics": song.lyrics,
              "item": song,
              "isAdded": isAdded,
            },
          );
        } catch (err) {
          print(err);
        }
        setState(() {
          isLoading = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(
            width: isLoading ? 3 : 0,
            color: isLoading ? Colors.white60 : Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "${item.title.length >= 23 ? item.title.substring(0, 23) + ".." : item.title}\n${item.artistName}",
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // if (isLoading) Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
