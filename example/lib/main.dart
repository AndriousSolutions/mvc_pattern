/// Note: This license has also been called the "Simplified BSD License" and the "FreeBSD License".
/// See also the 2-clause BSD License.
///
/// Copyright 2018 www.andrioussolutions.com
///
/// Redistribution and use in source and binary forms, with or without modification,
/// are permitted provided that the following conditions are met:
///
/// 1. Redistributions of source code must retain the above copyright notice,
/// this list of conditions and the following disclaimer.
///
/// 2. Redistributions in binary form must reproduce the above copyright notice,
/// this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
/// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
/// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
/// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
/// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/// To try this example,
/// Uncomment the import statement the line in the function, makeWordPairs(), below.
/// Of course, that means you'll have to modify your pubspec.yaml file.

import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

//import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends AppMVC {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key key}) : super(key: key);
  @override
  State createState() => _RandomWordsState();
}

class _RandomWordsState extends StateMVC<RandomWords> {
  _RandomWordsState() : super(Con()) {
    con = controller;
  }
  Con con;

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override

  /// the View
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                pushSaved(context);
              }),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once per suggested word pairing,
      // and places each suggestion into a ListTile row.
      // For even rows, the function adds a ListTile row for the word pairing.
      // For odd rows, the function adds a Divider widget to visually
      // separate the entries. Note that the divider may be difficult
      // to see on smaller devices.
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row in theListView.
        if (i.isOdd) {
          return const Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings in the ListView,
        // minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word pairings...
        if (index >= con.length) {
          // ...then generate 10 more and add them to the suggestions list.
          con.addAll(10);
        }
        return buildRow(index);
      },
    );
  }

  void pushSaved(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = this.tiles;

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget buildRow(int index) {
    if (index == null && index < 0) {
      index = 0;
    }

    final something = con.something(index);

    final alreadySaved = con.contains(something);

    return ListTile(
      title: Text(
        something,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          con.somethingHappens(something);
        });
      },
    );
  }

  Iterable<ListTile> get tiles => con.mapHappens(
        (String something) {
          return ListTile(
            title: Text(
              something,
              style: _biggerFont,
            ),
          );
        },
      );
}

class Con extends ControllerMVC {
  Con([StateMVC state]) : super(state) {
    data = Model();
  }
  Model data;

  int get length => data.length;

  void addAll(int count) => data.addAll(count);

  String something(int index) => data.wordPair(index);

  bool contains(String something) => data.contains(something);

  void somethingHappens(String something) => data.save(something);

  Iterable<ListTile> mapHappens<ListTile>(Function f) => data.saved(f);
}

class Model {
  final List<String> _suggestions = [];

  int get length => _suggestions.length;

  String wordPair(int index) {
    if (index == null || index < 0) {
      index = 0;
    }
    return _suggestions[index];
  }

  bool contains(String pair) {
    if (pair == null || pair.isEmpty) {
      return false;
    }
    return _saved.contains(pair);
  }

  final Set<String> _saved = {};

  void save(String pair) {
    if (pair == null || pair.isEmpty) {
      return;
    }

    final alreadySaved = contains(pair);

    if (alreadySaved) {
      _saved.remove(pair);
    } else {
      _saved.add(pair);
    }
  }

  Iterable<ListTile> saved<ListTile>(Function f) => _saved.map(f);

  Iterable<String> wordPairs([int count = 10]) => makeWordPairs(count);

  void addAll(int count) {
    _suggestions.addAll(wordPairs(count));
  }
}

Iterable<String> makeWordPairs(int count) {
  /// Uncomment the the line below to try this example.
  /// Of course, that means you'll have to modify your pubspec.yaml
  return generateWordPairs().take(count).map((pair) {
    return pair.asPascalCase;
  });
}
