import 'package:clicknshare/photoclicker_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        theme: ThemeData.light(),
        title: "Click N Share",
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        home: ClickPhotonVideo(),
      ),
    );
  }
}
