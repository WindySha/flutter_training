import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart';
import 'dart:async';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled, debugPaintBaselinesEnabled, debugPaintLayerBordersEnabled,
debugRepaintTextRainbowEnabled;

void main() {
//  debugPaintSizeEnabled = true;      //打开视觉调试开关
//  debugPaintBaselinesEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugRepaintTextRainbowEnabled = true;
  runApp(new App());
}

final wordPair = new WordPair.random();

class App extends StatelessWidget {
  var content = new RandomWords();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'my flutter app',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("titleBar"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.list),
//                onPressed: content.myState._pushSaved
                onPressed: (){
                  _showAlertDialog(content.myState.context);
                },
            ),
          ],
        ),
        body: content,
      ),
      theme: new ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/a': (context) => new MyRouteA(),
      },
    );
  }
}

Future<String> _showAlertDialog(BuildContext context) async {
  return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text("AlertDialog Title"),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text("aaaaaaaaaaaaaa"),
              new Text("bbbbbbbbbbbbbbbbb"),
              new Text("cccccccccccccccccccc"),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.of(context).pop("haha fanhuile");
              },
              child: new Text("Regret"))
        ],
      ),
    barrierDismissible: false,
  );
}

class RandomWords extends StatefulWidget {
  var myState = new MyRandomState();

  @override
  createState() => myState;
}

class MyRouteA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Icon(Icons.add_box),
      ),
      body: new Center(
        child: new FlatButton(
            onPressed: (){
              print("点击了");
//              _backPressed(context);
            },
            child: new Text("这是一个全新的界面，哈哈哈！！",
              style: new TextStyle(
                fontSize: 40.0,
              ),
              maxLines: 3,)),
      ),
    );
  }
}

class MyRandomState extends State<StatefulWidget> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _smallFont = const TextStyle(fontSize: 12.0);

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map(
        (pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
  
  void _pushSavedTest() async {
    String result = await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) =>
            new Scaffold(
              appBar: new AppBar(
                title: new Icon(Icons.add_box),
              ),
              body: new Center(
                  child: new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop("返回的结果!!");
//                        _backPressed(context);
                      },
                      child: new Text("这是一个全新的界面，哈哈哈！！",
                        style: new TextStyle(
                          fontSize: 40.0,
                        ),
                        maxLines: 3,)),
              ),
            )
    ));
    print("i have get the result = $result");
  }

  void _pushSavedTest2() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (context) => new MyRouteA(),
    ));
  }
  void _pushSavedTest3() {
    Navigator.of(context).pushNamed('/a');
  }

  _backPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildSuggestions() {
//    _suggestions.addAll(generateWordPairs().take(500));

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 40,
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;
          print("i=$i  index = $index");
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  void _onFavoriteIconPressed(WordPair pair) {
    setState(() {
      if (_saved.contains(pair)) {
        _saved.remove(pair);
      } else {
        _saved.add(pair);
      }
    });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      subtitle: new Text(
        "SubTitle is " + pair.asPascalCase,
        style: _smallFont,
      ),
      trailing: new GestureDetector(
        onTap: () {
          _onFavoriteIconPressed(pair);
        },
        child: getMyFavoriteIcon(alreadySaved),
      ),
      onTap: _pushSavedTest,
    );
  }

  getMyFavoriteIcon(alreadySaved) => new Icon(
    alreadySaved ? Icons.favorite : Icons.favorite_border,
    color: alreadySaved ? Colors.red : null,
    size: 40.0,
  );


//  @override
//  Widget build(BuildContext context) {
//    return (new Text(wordPair.asPascalCase));
//  }
  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}

