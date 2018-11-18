mvc_pattern
===========
[![Build Status](https://travis-ci.org/AndriousSolutions/mvc_pattern.svg?branch=master)](https://travis-ci.org/AndriousSolutions/mvc_pattern)
![flutter and mvc](https://user-images.githubusercontent.com/32497443/47087365-c9524f80-d1e9-11e8-85e5-6c8bbabb18cc.png)
###### The "Kiss" of Flutter Frameworks

In keeping with the ["KISS
Principle"](https://en.wikipedia.org/wiki/KISS_principle), this is an attempt to
offer the MVC design pattern to Flutter in an intrinsic fashion incorporating
much of the Flutter framework itself. All in a standalone Flutter Package. It is
expected the user of this package to be knowledgeable with such framework
architectures.

**Usage**

Let’s demonstrate its usage with the ol’ ‘Counter app’ created every time you
start a new Flutter project. In the example below, to utilize the package, three
things are changed in the Counter app. The Class, \_MyHomePageState, is extended
with the Class StateMVC, a ‘Controller’ Class is introduced that extends the
Class, ControllerMVC, and a static instance of that Class is made available to
the **build()** function. Done!

With that, there is now a separation of ‘the Interface’ and ‘the data’ as it’s
intended with the MVC architecture. The **build()** function (the View) is
concerned solely with the ‘look and feel’ of the app’s interface—‘how’ things
are displayed. While, in this case, it is the Controller that’s concerned with
‘what’ is displayed.

What data does the View display? It doesn’t know nor does it care! It ‘talks to’
the Controller instead. Again, it is the Controller that determines ‘what’ data
the View displays. In this case, it’s a title and a counter. When a button is
pressed, the View again ‘talks to’ the Controller to address the event
(i.e. It calls one of the Controller’s public functions,
**incrementCounter()**).
![myhomepage](https://user-images.githubusercontent.com/32497443/48669371-3c90ff00-ead1-11e8-810b-3372482750b1.jpg)

![mvc pattern](https://user-images.githubusercontent.com/32497443/47087587-6614ed00-d1ea-11e8-8fc3-ced0ac6af12a.jpg)

In this arrangement, the Controller is ‘talking back’ to the View by calling the
View’s function, **setState()**, to tell it to rebuild.

Maybe we don’t want that. Maybe we want the View to be solely concern with the
interface and only determine when to rebuild or not. It’s a simple change.

![view talks to contoller only](https://user-images.githubusercontent.com/32497443/47087650-88a70600-d1ea-11e8-8212-b785485a3dee.jpg)

![myhomepage](https://user-images.githubusercontent.com/32497443/47261691-e4031d80-d4a2-11e8-8d57-edf48a7949ae.jpg)
It does separate the ‘roles of responsibility’ a little more, doesn’t it? After
all, it is the View that’s concerned with the interface. It would know best when
to rebuild, no? Regardless, with this package, such things are left to the
developer. Also, notice what I did with the app’s title? I created a static
String field in the MyApp class called, title. It’s named ‘MyApp’ after all—It
should know its own title.

**How about Model?**

Currently, in this example, it’s the Controller that’s containing all the
‘business logic’ for the application. In some MVC implementations, it’s the
Model that contains the business rules for the application. So how would that
look? Well, it maybe could look like this:
![controller](https://user-images.githubusercontent.com/32497443/47087743-ca37b100-d1ea-11e8-9e38-92acea125668.jpg)
I decided to make the Model’s API a little cleaner with the use of a static
members. As you can deduce, the changes were just made in the Controller. The
View doesn’t even know the Model exists. It doesn’t need to. It still ‘talks to’
the Controller, but it is now the Model that has all the ‘brains.’

![pac pattern](https://camo.githubusercontent.com/a5b152ecc2f2b96b8019941a7382f47f4ac4c2b6/68747470733a2f2f692e696d6775722e636f6d2f723443317932382e706e67)

However, what if you want the View to talk to the Model? Maybe because the Model
has zillions of functions, and you don’t want the Controller there merely ‘to
relay’ the Model’s functions and properties over to the View. You could simply
provide the Model to the View. The View then calls the Model’s properties and
functions directly.

![mvc pattern classic](https://user-images.githubusercontent.com/32497443/47087797-ef2c2400-d1ea-11e8-8a90-41bbb6b07bf0.jpg)

![myhomepagestate](https://user-images.githubusercontent.com/32497443/47087832-0b2fc580-d1eb-11e8-8977-0c2bc206e8be.jpg)
Not particularly pretty. I would have just kept the Static members in the Model,
and have the View call them instead (or not do that at all frankly), but I’m
merely demonstrating the possibilities. With this MVC implementation, you have
options, and developers love options.

# The Counter App
Below is the full Counter App with the MVC implementation. 
```dart
import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}
```
```dart
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // Fields in a Widget subclass are always marked "final".

  static final String title = 'Flutter Demo Home Page';

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
```
```dart
class _MyHomePageState extends StateMVC {

  _MyHomePageState():super(Controller()){

    _con = Controller.con;
  }
  Controller _con;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(MyHomePage.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(MyHomePage.title,
            ),
            new Text(
              '${_con.displayThis}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          setState(
            _con.whatever
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```
```dart
class Controller extends ControllerMVC {
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static Controller get con => _this;

  @override
  initState() {
    /// Demonstrating how the 'initState()' is easily implemented.
    _counter = Model.counter;
  }

  int get displayThis => _counter;
  int _counter;
  void whatever() {
    /// The Controller knows how to 'talk to' the Model. It knows the name, but Model does the work.
    _counter = Model._incrementCounter();
  }
}
```
```dart
class Model{

  static int get counter => _counter;
  static int _counter = 0;

  static int _incrementCounter(){
    return ++_counter;
  }
}
```
# Your First Flutter App: startup_namer
This is the application offered in the website, [Write Your First Flutter App](https://flutter.io/get-started/codelab/),
when you're first learning Flutter. This version has this MVC implementation.  
### MyApp.dart
```dart
import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

void main() => runApp(MyApp());

class MyApp extends AppMVC {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}
```
## StateView
Note the two classes below. RandomWords is extended by the StatefulWidgetMVC and the other, RandomWordsState, 
 extended by StateMVC. With the class, RandomWords, the super constructor is passed the 'State Object', RandomWordsState (StateMVC).
In turn, the State Object takes in the Controller Class, Con. 
### RandomWords.dart
```dart
import 'package:mvc_pattern/mvc_pattern.dart';

class RandomWords extends StatefulWidgetMVC {
  RandomWords() : super(RandomWordsState(Con()));
}

class RandomWordsState extends StateMVC {
  RandomWordsState(Con con) : super(con);

  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

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
      padding: const EdgeInsets.all(16.0),
      // The itemBuilder callback is called once per suggested word pairing,
      // and places each suggestion into a ListTile row.
      // For even rows, the function adds a ListTile row for the word pairing.
      // For odd rows, the function adds a Divider widget to visually
      // separate the entries. Note that the divider may be difficult
      // to see on smaller devices.
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row in theListView.
        if (i.isOdd) return Divider();

        // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings in the ListView,
        // minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word pairings...
        if (index >= Con.length) {
          // ...then generate 10 more and add them to the suggestions list.
          Con.addAll(10);
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
    if (index == null && index < 0) index = 0;

    String something = Con.something(index);

    final alreadySaved = Con.contains(something);

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
          Con.somethingHappens(something);
        });
      },
    );
  }

  Iterable<ListTile> get tiles => Con.mapHappens(
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
```
### Controller.dart 
Note how its all made up of static members and turns to Model for all the data.
```dart
import 'package:mvc_pattern/mvc_pattern.dart';

class Con extends ControllerMVC {
  static int get length => Model.length;

  static void addAll(int count) => Model.addAll(count);

  static String something(int index) => Model.wordPair(index);

  static bool contains(String something) => Model.contains(something);

  static void somethingHappens(String something) => Model.save(something);

  static Iterable<ListTile> mapHappens<ListTile>(Function f) => Model.saved(f);
}
```
### Model.dart
This Model works with the third-party library, english_words. The rest of the application has no idea.
The Model is solely concern with where the 'words' originate from.
```dart
import 'package:english_words/english_words.dart';

class Model {
  static final List<String> _suggestions = [];
  static int get length => _suggestions.length;

  static String wordPair(int index) {
    if (index == null || index < 0) index = 0;
    return _suggestions[index];
  }

  static bool contains(String pair) {
    if (pair == null || pair.isEmpty) return false;
    return _saved.contains(pair);
  }

  static final Set<String> _saved = Set();

  static void save(String pair) {
    if (pair == null || pair.isEmpty) return;
    final alreadySaved = contains(pair);
    if (alreadySaved) {
      _saved.remove(pair);
    } else {
      _saved.add(pair);
    }
  }

  static Iterable<ListTile> saved<ListTile>(Function f) => _saved.map(f);

  static Iterable<String> wordPairs([int count = 10]) => makeWordPairs(count);

  static void addAll(int count) {
    _suggestions.addAll(wordPairs(count));
  }
}

Iterable<String> makeWordPairs(int count) {
  return generateWordPairs().take(count).map((pair){return pair.asPascalCase;});
}
```

Further information on the MVC package can be found in the article, [‘Flutter + MVC at Last!’](https://medium.com/p/275a0dc1e730/)
[![online article](https://user-images.githubusercontent.com/32497443/47087365-c9524f80-d1e9-11e8-85e5-6c8bbabb18cc.png)](https://medium.com/flutter-community/flutter-mvc-at-last-275a0dc1e730)
[Repository (GitHub)](https://github.com/AndriousSolutions/mvc_pattern)

[API Docs](https://pub.dartlang.org/documentation/mvc_pattern/latest/mvc_pattern/mvc_pattern-library.html)
