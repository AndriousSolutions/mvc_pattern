mvc_pattern
===========
[![Build Status](https://travis-ci.org/AndriousSolutions/mvc_pattern.svg?branch=master)](https://travis-ci.org/AndriousSolutions/mvc_pattern)
![flutter and mvc](https://user-images.githubusercontent.com/32497443/47087365-c9524f80-d1e9-11e8-85e5-6c8bbabb18cc.png)
###### The "Kiss" of Flutter Frameworks
In keeping with the ["KISS Principle"](https://en.wikipedia.org/wiki/KISS_principle), this is an attempt to offer the MVC design pattern to Flutter in an intrinsic fashion incorporating much of the Flutter framework itself. All in a standalone Flutter Package.

**Usage**
Let’s demonstrate its usage with the ol’ ‘Counter app’ created every time you start a new Flutter project. In the example below, to utilize the package, three things are changed in the Counter app. The Class, \_MyHomePageState, is extended with the Class StateMVC, a ‘Controller’ Class is introduced. It extends the Class, ControllerMVC, and a static instance of that Class is made available to the **build()** function. Done! (Note, you will find the 'source code' for this example in this package's [test](https://github.com/AndriousSolutions/mvc_pattern/tree/master/test)  folder.

With that, there's now a separation of ‘the Interface’ and ‘the data’ as 
intended with the MVC architecture. The **build()** function serves as 'the View.' It's concerned solely with the ‘look and feel’ of the app’s interface—‘how’ things are displayed. While it is the Controller that determines 'what’ is displayed. The Controller is also concerned with 'how' the app interacts with the user, and so it's involved in the app's event handling.

What data does the View display? It doesn’t know nor does it care! It ‘talks to’
the Controller instead. Again, it is the Controller that determines ‘what’ data
the View displays. In this example, it’s a title and a counter. And when a button is pressed, the View again ‘talks to’ the Controller to address the event
(i.e. calls one of the Controller’s public functions, **incrementCounter()**).
![myhomepage](https://user-images.githubusercontent.com/32497443/48676501-dab6b080-eb35-11e8-93ab-8bbfc6f8bc6b.jpg)
In this arrangement, the Controller is ‘talking back’ to the View by calling the
View’s function, **setState()**, telling it to rebuild the widget tree.

![viewandcontroller](https://user-images.githubusercontent.com/32497443/48676337-6844d100-eb33-11e8-8405-be476668f431.jpg)

Maybe we don’t want that. Maybe we want the View to be solely concern with the
interface and solely determine when to rebuild the widget tree or not. It’s a simple change.
![myhomepage2](https://user-images.githubusercontent.com/32497443/48676526-13ef2080-eb36-11e8-8c7a-d1dc5886b39f.jpg)
The View knows how to 'talk to' the Controller, but the Controller doesn't need to know how to 'talk to' the View.
Notice what I did to the Controller? Makes the API between the View and the Controller a little clearer.

![view talks to contoller only](https://user-images.githubusercontent.com/32497443/47087650-88a70600-d1ea-11e8-8212-b785485a3dee.jpg)

It does separate the ‘roles of responsibility’ a little more, doesn’t it? After
all, it is the View that’s concerned with the interface. It would know best when
to rebuild, no? Regardless, with this package, such things are left to the
developer. Lastly, notice how I created a static String field in the MyApp class called, title.
It’s named ‘MyApp’ after all—It should know its own title.

![myapp](https://user-images.githubusercontent.com/32497443/48676941-e4431700-eb3b-11e8-8d3a-8010a0bb0bcf.jpg)
You see in the 'App' class above, that the Controller is instantiated in the parent class.
Doing so allows your Controller to now access the many ['events'](https://medium.com/flutter-community/flutter-mvc-at-last-275a0dc1e730#7ebe) 
fired in a typical Flutter app.

**How about Model?**

Currently, in this example, it’s the Controller that’s containing all the
‘business logic’ for the application. In some MVC implementations, it’s the
Model that contains the business rules for the application. So how would that
look? Well, it maybe could look like this:
![howaboutmodel](https://user-images.githubusercontent.com/32497443/48677268-36863700-eb40-11e8-8fb3-29e2605b5dc1.jpg)
The Model’s API is also a little cleaner with the use of a static
members. The View doesn’t even know the Model exists. It doesn’t need to.
It still ‘talks to’ the Controller, but it is now the Model that has all the ‘brains.’

Note above, it's a full screenshot of the counter app example, and there's further 
changes made compared to the previous examples. Note, the State object again extends ```StateMVC```
and the 'MyApp' class is returned to StatelessWidget. Allows the State object to
address events instead. Here, the Controller is passed to its parent class to 'plug it into' the 
event handling of a typical Flutter Widget. Finally, note the Controller's 
property and function names have been changed. This merely demonstrates that
there's no 'hard cold rules' about what the API is between the View,
the Controller, and the Model. You merely need to be consistent so they can 'talk to' each other.

![pac pattern](https://camo.githubusercontent.com/a5b152ecc2f2b96b8019941a7382f47f4ac4c2b6/68747470733a2f2f692e696d6775722e636f6d2f723443317932382e706e67)

However, what if you want the View to talk to the Model? Maybe because the Model
has zillions of functions, and you don’t want the Controller there merely ‘to
relay’ the Model’s functions and properties over to the View. You could simply
provide the Model to the View. The View can then call the Controller's properties and
functions as well the Model’s.

![viewcantalk](https://user-images.githubusercontent.com/32497443/48677829-c29c5c80-eb48-11e8-831a-42912fe44a10.jpg)
![viewtomodel](https://user-images.githubusercontent.com/32497443/48677706-d34bd300-eb46-11e8-931e-c0fb96f40522.jpg)
Not particularly pretty. I mean, at this point, you don't even need 'the Controller', 
but it merely demonstrates the possibilities.
With this MVC implementation, you have options, and developers love options.

![viewcontrollermodel](https://user-images.githubusercontent.com/32497443/48679035-22026880-eb59-11e8-96aa-f689f1f8898f.jpeg)

Below, I've changed it a little bit. The View still has access to the Model, but the Controller is still
responsible for any 'event handling' and responds to the user pressing that lone button in the app.
![viewtomodel2](https://user-images.githubusercontent.com/32497443/48677674-60daf300-eb46-11e8-8bd9-fdf3f6ba9a6d.jpg)

# The Counter App
Below is the Counter App you can copy n' paste to quickly try out: 
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
class _MyHomePageState extends State<MyHomePage> {

  final Controller _con = Controller.con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
            ),
            Text(
              '${_con.counter}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
              _con.incrementCounter
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```
```dart
class Controller extends ControllerMVC {
  /// Singleton Factory
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static Controller get con => _this;

  int get counter => _counter;
  int _counter = 0;
  void incrementCounter() => _counter++;
}
```
Now you can easily introduce a Model: 
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

  int get counter => Model.counter;
  void incrementCounter() {
    /// The Controller knows how to 'talk to' the Model. It knows the name, but Model does the work.
    Model._incrementCounter();
  }
}
```
```dart
class Model {
  static int get counter => _counter;
  static int _counter = 0;
  static int _incrementCounter() => ++_counter;
}
```
Of course, you're free to 'switch out' variations of the Controller over time. In this case, you no longer need to assign a
local variable, ```_con```, but instead use a static reference: ```Controller.incrementCounter;```
```dart
class Controller extends ControllerMVC {
  static int get counter => Model.counter;
  static void incrementCounter() => Model._incrementCounter();
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
# DECODE Flutter
##### Live Streaming every week. Everything to do about Flutter. 
[![twitch](https://user-images.githubusercontent.com/32497443/49753449-7349d780-fc81-11e8-9d08-89146a6731c8.png)
](https://medium.com/@greg.perry/decode-flutter-6b60a3199e83)

[Repository (GitHub)](https://github.com/AndriousSolutions/mvc_pattern)

[API Docs](https://pub.dartlang.org/documentation/mvc_pattern/latest/mvc_pattern/mvc_pattern-library.html)
