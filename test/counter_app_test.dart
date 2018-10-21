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

import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidgetMVC {
  MyHomePage({Key key}) : super(_MyHomePageState(), key: key);

  // Fields in a Widget subclass are always marked "final".

  static final String title = 'Flutter Demo Home Page';
}


class View extends ViewMVC{
   View():super(Controller()){
     _con = controller;
   }
   Controller _con;

   @override
   Widget build(BuildContext context) {
     // This method is rerun every time setState is called.
     //
     // The Flutter framework has been optimized to make rerunning build methods
     // fast, so that you can just rebuild anything that needs updating rather
     // than having to individually change instances of widgets.
     return Scaffold(
       appBar: AppBar(
         // Here we take the value from the MyHomePage object that was created by
         // the App.build method, and use it to set our appbar title.
         title: Text(MyHomePage.title),
       ),
       body: Center(
         // Center is a layout widget. It takes a single child and positions it
         // in the middle of the parent.
         child: Column(
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
             Text(MyHomePage.title,
             ),
             Text(
               '${_con.displayThis}',
               style: Theme.of(context).textTheme.display1,
             ),
           ],
         ),
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: (){
           setState(
               _con.whatever
           );
         },
         tooltip: 'Increment',
         child: Icon(Icons.add),
       ), // This trailing comma makes auto-formatting nicer for build methods.
     );
   }
}


class _MyHomePageState extends StateViewMVC {

  _MyHomePageState():super(View()){

    _con = Controller.con;
  }
  Controller _con;
}


class Controller extends ControllerMVC{

  Controller(){
    con = this;
  }
  static Controller con;

  @override
  initState(){
    /// Demonstrating how the 'initState()' is easily implemented.
    _counter = Model.counter;
  }

  int get displayThis => _counter;
  int _counter;

  void whatever(){
    /// The Controller knows how to 'talk to' the Model. It knows the name, but Model does the work.
    _counter = Model._incrementCounter();
  }
}
class Model{

  static int get counter => _counter;
  static int _counter = 0;

  static int _incrementCounter(){
    return ++_counter;
  }
}

