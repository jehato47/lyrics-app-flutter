import 'package:flutter/material.dart';

class SliverScreen extends StatelessWidget {
  static const url = "/sliver-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SliverList"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Text("weqew"),
              TextFormField(),
              Container(
                height: 600,
                color: Colors.blue,
              )
            ]),
          )
        ],
      ),
    );
  }
}
