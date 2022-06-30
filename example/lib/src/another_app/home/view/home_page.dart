// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  The StatefulWidget representing the app's Home Page.
///
import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:example/src/another_app/home/view.dart';

/// The Home page
class HomePage extends StatefulWidget {
  ///
  const HomePage({Key? key, this.title}) : super(key: key);

  ///
  final String? title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateMVC<HomePage> {
  _HomePageState() : super(HomeController()) {
    con = controller as HomeController;
  }
  late HomeController con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Inherited State Object Demo.'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: InheritBird(
        child: InheritCat(
          child: InheritDog(
            child: InheritFox(
              child: GridView.count(
                crossAxisCount: 3,
                children: con.children,
              ),
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: OverflowBar(
            spacing: 16,
            overflowAlignment: OverflowBarAlignment.end,
            children: [
              TextButton(
                onPressed: () => con.newDogs(),
                child: const Text('New Dogs'),
              ),
              TextButton(
                onPressed: () => con.newCats(),
                child: const Text('New Cats'),
              ),
              TextButton(
                onPressed: () => con.newFoxes(),
                child: const Text('New Foxes'),
              ),
              TextButton(
                onPressed: () => con.newBirds(),
                child: const Text('New Birds'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
