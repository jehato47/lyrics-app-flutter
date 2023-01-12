import 'package:flutter/material.dart';
import 'package:lyrics/providers/song.dart';
// import 'package:lyrics/widgets/song_list.dart';
import 'package:provider/provider.dart';
// import '../providers/search.dart';

class SearchedDetailScreen extends StatefulWidget {
  static const url = "/searched-detail";

  @override
  _SearchedDetailScreenState createState() => _SearchedDetailScreenState();
}

class _SearchedDetailScreenState extends State<SearchedDetailScreen> {
  bool isAdded = false;
  bool isDisabled = false;
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      var arg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      isAdded = arg["isAdded"];
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Song song = args["item"] as Song;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/mic.jpeg"),
          colorFilter: ColorFilter.mode(Colors.blueGrey, BlendMode.modulate),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text("${song.name} - ${song.artist}"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(isAdded ? Icons.done : Icons.add),
            onPressed: () async {
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

                setState(() {
                  isAdded = false;
                  isDisabled = false;
                });
                return;
              }
            }),
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
                    args["lyrics"],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: '\n'.allMatches(args["lyrics"]).length + 1 < 20
                          ? 15.5
                          : 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
