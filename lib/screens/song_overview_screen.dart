import 'package:flutter/material.dart';
import 'package:lyrics/providers/auth.dart';
import 'package:lyrics/screens/search_song_screen.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';
import '../widgets/song_list.dart';
// import 'add_song_screen.dart';

class SongOverviewScreen extends StatefulWidget {
  @override
  _SongOverviewScreenState createState() => _SongOverviewScreenState();
}

class _SongOverviewScreenState extends State<SongOverviewScreen> {
  bool onError = false;
  bool isLoading = true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<SongListP>(context).fetchAndSetSongs().then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          onError = true;
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  Future<void> refreshScreen() async {
    setState(() {
      isLoading = true;
      onError = false;
    });
    Provider.of<SongListP>(context).fetchAndSetSongs().then((value) {
      setState(() {
        isLoading = false;
        onError = false;
      });
    }).catchError((err) {
      setState(() {
        onError = true;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/songover.jpeg"),
        ),
      ),
      child: Scaffold(
        // backgroundColor: Colors.blueGrey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                }),
            AnimatedContainer(
              width: onError ? 100 : 50,
              duration: Duration(milliseconds: 300),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        SearchSongScreen.url,
                      );
                    },
                  ),
                  if (onError)
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          await refreshScreen();
                        },
                      ),
                    )
                ],
              ),
            )
          ],
          title: Text(
            "Lyrics App",
          ),
        ),
        body: onError
            ? RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<SongListP>(context).fetchAndSetSongs();
                },
                child: Center(child: Text("An error occured")))
            : isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      refreshScreen();
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: SongList(),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
