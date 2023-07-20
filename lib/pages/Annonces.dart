import 'package:firebase_auth/firebase_auth.dart';

import 'responsive.dart';
import '../widget/Widget.dart';
import '../widget/footer_widget.dart';
import '../widget/menu_drawer.dart';
import '../widget/top_bar.dart';
import 'package:flutter/material.dart';

class Annonces extends StatefulWidget {
  const Annonces({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Annonces> {
  final ScrollController _scrollController = ScrollController();

  double _opacity = 0;
  double _screenPosition = 0;

  _scrollListener() {
    setState(() {
      _screenPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _opacity = _screenPosition < _screenSize.height * 0.40
        ? _screenPosition / (_screenSize.height * 0.40)
        : 1;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: _screenSize.height * 0.10,
                      left: _screenSize.width / 10,
                      right: _screenSize.width / 10),
                  child: Column(
                    children: [
                      ConverterWidget(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}