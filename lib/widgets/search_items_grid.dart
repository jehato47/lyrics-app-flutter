import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/search_item.dart';
import '../providers/search.dart';

class SearchItemGrid extends StatelessWidget {
  final SearchProvider value;

  SearchItemGrid(this.value);
  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 5 / 4,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: value.searchList.map((e) {
        return ChangeNotifierProvider.value(
          value: Search(
            id: e.id,
            artistName: e.artistName,
            imgUrl: e.imgUrl,
            path: e.path,
            title: e.title,
          ),
          child: SearchItem(),
        );
      }).toList(),
    );
  }
}
