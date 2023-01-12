import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Song extends ChangeNotifier {
  String? id;
  String? name;
  String? artist;
  String? lyrics;

  Song({
    this.id,
    this.name,
    this.artist,
    this.lyrics,
  });
}

class SongListP extends ChangeNotifier {
  String? token;
  String? userId;

  List<Song> _songs = [];

  SongListP(
    this.token,
    this.userId,
    this._songs,
  );

  List<Song> get songs {
    return [..._songs];
  }

  Song findById(String id) {
    return _songs.firstWhere((element) => id == element.id);
  }

  bool isAdded(Song? song) {
    return _songs.any((element) {
      if (element.name == song?.name && element.artist == song?.artist) {
        return true;
      }
      return false;
    });
  }

  Future<void> addSong(Song? song) async {
    var url =
        "https://master-imagery-289619-default-rtdb.firebaseio.com/lyrics/$userId.json?auth=$token";
    // final check = _songs.indexWhere((element) {
    //   if (element.artist == song.artist && element.name == song.name) {
    //     return true;
    //   }
    //   return false;
    // });

    // if (check != -1) {
    //   throw Exception("Still have this song");
    // }
    await http
        .post(
      url,
      body: json.encode({
        "artist": song?.artist,
        "name": song?.name,
        "lyrics": song?.lyrics,
      }),
    )
        .then((response) {
      String id = json.decode(response.body)["name"];
      _songs.add(
        Song(
          artist: song?.artist,
          name: song?.name,
          id: id,
          lyrics: song?.lyrics,
        ),
      );
    }).catchError((error) {
      throw error;
    });
    notifyListeners();
  }

  Future<void> fetchAndSetSongs() async {
    // print(token);
    var url =
        "https://master-imagery-289619-default-rtdb.firebaseio.com/lyrics/$userId.json?auth=$token";

    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _songs = [];
      notifyListeners();
      return;
    }
    List<Song> rList = [];
    extractedData.forEach((key, value) {
      rList.add(
        Song(
          id: key,
          artist: value["artist"],
          name: value["name"],
          lyrics: value["lyrics"],
        ),
      );
    });

    _songs = rList;

    notifyListeners();
  }

  Future<void> updateItem(Song song) async {
    var url =
        "https://master-imagery-289619-default-rtdb.firebaseio.com/lyrics/$userId.json?auth=$token";

    try {
      await http.patch(url,
          body: json.encode(
            {
              song.id: {
                "artist": song.artist,
                "name": song.name,
                "lyrics": song.lyrics,
              }
            },
          ));

      final index = _songs.indexWhere((element) => element.id == song.id);
      _songs[index] = song;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> removeItem(Song? song) async {
    var songIdx;
    var existingSong;
    try {
      songIdx = _songs.indexWhere((element) {
        if (element.name == song!.name && element.lyrics == song.lyrics) {
          print(element.id);
          return true;
        }
        return false;
      });

      existingSong = _songs[songIdx];
      var url =
          "https://master-imagery-289619-default-rtdb.firebaseio.com/lyrics/$userId/${existingSong.id}.json?auth=$token";
      _songs.removeAt(songIdx);
      notifyListeners();
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _songs.insert(songIdx, existingSong);
        notifyListeners();
      }
    } catch (err) {
      print(err);
      _songs.insert(songIdx, existingSong);
      notifyListeners();
    }
  }
}
