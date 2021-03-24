import 'package:flutter/material.dart';
import 'package:lyrics/widgets/search_items_grid.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';
// import '../widgets/search_item.dart';
import '../providers/search.dart';

class SearchSongScreen extends StatefulWidget {
  static const url = "/search-screen";

  @override
  _SearchSongScreenState createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) => Provider.of<SearchProvider>(context).cleanList(),
    );
    song = Song();
    super.initState();
  }

  String artist;
  Song song;
  bool onGrid = false;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Search> searchList = [];
  bool isAdded = false;
  bool isDisabled = false;
  @override
  Widget build(BuildContext context) {
    // bool isAdded = false; eğer bunu buraya koyarsan
    // her setState te tekrar false olur

    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/gitar.jpeg"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            titleSpacing: 0,
            actions: [
              IconButton(
                icon: Icon(onGrid ? Icons.change_history : Icons.grid_on),
                onPressed: () {
                  setState(() {
                    onGrid = !onGrid;
                  });
                },
              ),
            ],
            title: Text(artist != null && !onGrid ? artist : "Add lyrics"),
          ),
          floatingActionButton: !onGrid
              ? FloatingActionButton(
                  child: Icon(isAdded ? Icons.done : Icons.add),
                  onPressed: () async {
                    if (song.name == null || song.lyrics == null) return;

                    try {
                      if (isDisabled) {
                        print("dis");
                        return;
                      }
                      if (isAdded != false) {
                        setState(() {
                          isAdded = false;
                          isDisabled = true;
                        });
                        await Provider.of<SongListP>(context).removeItem(song);
                        setState(() {
                          isDisabled = false;
                        });
                        return;
                      }
                      setState(() {
                        isDisabled = true;

                        isAdded = true;
                      });
                      await Provider.of<SongListP>(context).addSong(song);
                      setState(() {
                        isDisabled = false;
                      });
                    } catch (err) {
                      print(err);
                      if (err.toString() != "Exception: Still have this song") {
                        setState(() {
                          isAdded = false;
                          isDisabled = false;
                        });
                        return;
                      }
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
                    }
                  })
              : null,
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Enter a song name",
                      fillColor: Colors.black54,
                    ),
                    onChanged: (v) async {},
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a song name";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) async {
                      bool isValid = _form.currentState.validate();
                      if (!isValid) return;
                      setState(() {
                        searchList = [];
                        isAdded = false;
                        _isLoading = true;
                      });

                      // print(lyrics);
                      await Provider.of<SearchProvider>(context, listen: false)
                          .fetchSongs(value);
                      song = await Provider.of<SearchProvider>(context)
                          .parseLyrics(value);
                      setState(() {
                        isAdded = Provider.of<SongListP>(context).isAdded(song);
                        artist = song.artist;

                        _isLoading = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: onGrid ? 502 : null,
                    child: Consumer<SearchProvider>(
                      builder: (context, value, child) {
                        return _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : value.searchList.length == 0
                                ? Text(
                                    !onGrid
                                        ? "For detail search enter song name and artist name"
                                        : "For recommendeds enter a song name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
                                : !onGrid
                                    ? Expanded(
                                        child: SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black26,
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              song != null
                                                  ? "${song.lyrics}"
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                              // textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: SearchItemGrid(value));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
