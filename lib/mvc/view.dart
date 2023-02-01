import 'package:flutter/material.dart';

import 'controller.dart';

class MvcView extends StatefulWidget {
  const MvcView({Key? key}) : super(key: key);

  @override
  State<MvcView> createState() => _MvcViewState();
}

class _MvcViewState extends State<MvcView> {
  final String title = 'MVC Demo';
  final String title1 = 'Push Buttons to increase and decrease value.';
  final Controller _con = Controller();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Hellow"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                "Test"
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[FloatingActionButton(
                onPressed: () {
                  setState(
                      _con.decrementCounter
                  );
                },
                tooltip: 'Decrement',
                child: Icon(Icons.remove),
              ),Text(
                _con!=null?
                '${_con.counter}':"hi",
              ),FloatingActionButton(
                onPressed: () {
                  setState(
                      _con.incrementCounter
                  );
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),],
            ),
          ],
        ),
      ),


    );
  }
}
