// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// The first page displayed in this app.
class Page1 extends StatefulWidget {
  Page1({Key? key})
      : con = Controller(),
        super(key: key);
  final Controller con;

  @override
  State createState() => Page1State();

  ///
  void onPressed() {
    // See the number of ways to retrieve a State object.
    // by its StatefulWidget
    var state = con.stateOf<Page1>();
    // by its type
    state = con.ofState<Page1State>();

    final pageState = state as Page1State;

    state.setState(() {
      pageState.count++;
    });
  }
}

class Page1State extends StateMVC<Page1> {
  //
  @override
  void initState() {
    /// Link with the StateMVC so con.setState(() {}) will work.
    add(widget.con);
    con = controller as Controller;

    /// Allow the con.initState() to be called.
    super.initState();
  }

  late Controller con;

  int count = 0;

  // Responsible for the incrementation
  void onPressed() {
    count++;
    setState(() {});
//          buildInherited();
  }

  @override
  Widget build(context) {
    // Takes this state object as a dependency to an InheritedWidget.
    // Link this widget to the InheritedWidget
    // Only useful if buildInherited() is used instead of setState().
    dependOnInheritedWidget(context);
    return buildPage1(
      count: count,
      counter: onPressed,
    );
  }

  Widget buildPage1({
    int count = 0,
    required void Function() counter,
  }) =>
      BuildPage(
        label: '1',
        count: count,
        counter: counter,
        row: (BuildContext context) => [
          const SizedBox(),
          ElevatedButton(
            key: const Key('Page 2'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Page2(),
                ),
              );
            },
            child: const Text(
              'Page 2',
            ),
          ),
        ],
      );
}
