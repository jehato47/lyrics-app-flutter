import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../providers/song.dart';
// import 'package:html/dom.dart';

class Search extends ChangeNotifier {
  String? artistName;
  String? title;
  String? id;
  String? imgUrl;
  String? path;
  bool? isFavorite;

  Search({
    this.id,
    this.title,
    this.artistName,
    this.path,
    this.imgUrl,
    this.isFavorite,
  });
}

class SearchProvider extends ChangeNotifier {
  List<Search> _searchList = [];

  List<Search>? get searchList {
    if (_searchList == []) return null;
    return [..._searchList];
  }

  Future<void> fetchSongs(String keyword) async {
    _searchList = [];
    var url =
        "https://api.musixmatch.com/ws/1.1/track.search?format=json&callback=callback&s_track_rating=desc&q_track=$keyword&apikey=075f61f5e6c938b8be0a7634e428f175";
    final response = await http.get(url);
    final parsedData = json.decode(response.body) as Map<String, dynamic>;
    final x = parsedData["message"]["body"]["track_list"];

    // final favoritesResponse = await http.get(favoriteSongsUrl);
    // final favorites =
    //     json.decode(favoritesResponse.body) as Map<String, dynamic>;
    // favorites.forEach((key, value) {
    //   print(value["artist"]);
    //   print(value["name"]);
    // });

    x.forEach((element) {
      _searchList.add(
        Search(
          title: element["track"]["track_name"],
          path: 'element["result"]["path"]',
          id: element["track"]["track_id"].toString(),
          imgUrl: 'element["result"]["header_image_url"]',
          artistName: element["track"]["artist_name"],
        ),
      );
    });

    notifyListeners();
  }

  void cleanList() {
    _searchList = [];
    notifyListeners();
  }

  Future<Song> parseLyrics(String query) async {
    Song item = Song();

    try {
      var url = "https://www.google.com/search?q=$query sözleri";
      final response = await http.get(url);
      var document = parse(response.body);
      List<String> liste = [];
      document.querySelectorAll(".BNeawe.tAd8D.AP7Wnd").forEach((element) {
        liste.add(element.text);
      });
      var name = document.querySelector("span.BNeawe.tAd8D.AP7Wnd").text;
      var artist = document.querySelectorAll(".BNeawe.s3v9rd.AP7Wnd");

      item.artist = artist[1].text;
      item.name = name;
      liste.sort((a, b) => a.length.compareTo(b.length));
      var reversedList = new List.from(liste.reversed);
      var lyrics = reversedList[0] as String;

      if (lyrics.length < 50) {
        throw "Bulunamadı";
      }
      item.lyrics = lyrics;
      return item;
    } catch (err) {
      print("errrorr");
      print(err);
      throw "Bulunamadı";
    }
  }

  Search findById(String id) {
    return _searchList.firstWhere((element) => element.id == id);
  }
}
