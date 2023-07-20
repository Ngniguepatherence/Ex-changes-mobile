import 'package:flutter/material.dart';
import 'service.dart';

class Ads extends StatefulWidget {
  const Ads({super.key});
  @override
  _Ads createState() => _Ads();
}

class _Ads extends State<Ads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddTaskAlertDialog()));
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
