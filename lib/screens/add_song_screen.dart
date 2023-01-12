import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song.dart';

class AddSongScreen extends StatefulWidget {
  static const url = "/add-song";

  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  bool onError = false;
  bool _isInit = true;

  bool _isLoading = false;
  bool _forUpdate = false;
  Future<void> _saveForm() async {
    var a = _form.currentState!.validate();
    if (!a) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();
    final songListProvider = Provider.of<SongListP>(context, listen: false);

    await songListProvider.updateItem(song).then((response) {
      if (onError == true)
        setState(() {
          onError = false;
          _isLoading = false;
        });
    }).catchError((err) {
      setState(() {
        onError = true;
        _isLoading = false;
      });
    });

    if (onError) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) song = ModalRoute.of(context)!.settings.arguments as Song;
    _isInit = false;
    super.didChangeDependencies();
  }

  var song = Song(
    id: "",
    name: "",
    lyrics: "",
  );

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/images/mic.jpeg",
          ),
          colorFilter: ColorFilter.mode(
            Colors.white38,
            BlendMode.modulate,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(onError ? "Error Occured" : "Add lyric"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                        initialValue: song.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a name";
                          }
                          return null;
                        },
                        // scrollPadding: EdgeInsets.all(5),
                        cursorColor: Colors.black,
                        onSaved: (value) {
                          song = Song(
                            id: song.id,
                            name: value,
                            artist: song.artist,
                            lyrics: song.lyrics,
                          );
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Lyrics",
                          labelStyle: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                        initialValue: song.lyrics,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Lyrics";
                          }
                          return null;
                        },
                        cursorColor: Colors.black,
                        maxLines: 20,
                        onFieldSubmitted: (value) async {
                          await _saveForm();
                        },
                        onSaved: (value) {
                          song = Song(
                            id: song.id,
                            name: song.name,
                            artist: song.artist,
                            lyrics: value,
                          );
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      ElevatedButton(
                        // color: Colors.black38,
                        onPressed: () async {
                          await _saveForm();
                        },
                        child: Text(
                          onError
                              ? "resend"
                              : _forUpdate
                                  ? "update"
                                  : "save",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
