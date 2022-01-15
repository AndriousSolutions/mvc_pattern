// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// The second page displayed in this app.
class Page2 extends StatefulWidget {
  Page2({Key? key})
      : con = Controller(),
        super(key: key);
  final Controller con;

  @override
  State createState() => _Page2State();

  void onPressed() {
    //
    final state = con.ofState<_Page2State>()!;

    state.setState(() {
      con.incrementCounter();
    });
  }
}

/// This works with a separate 'data source'
/// It doesn't no what, but being so, the count is never reset to zero.
class _Page2State extends StateMVC<Page2> {
  @override
  void initState() {
    /// Make this the 'current' State object for the Controller.
    add(widget.con);
    con = controller as Controller;

    /// Allow for con.initState() function to fire.
    super.initState();
  }

  //
  late Controller con;

  @override
  Widget build(BuildContext context) => BuildPage(
        label: '2',
        count: con.count,
        counter: widget.onPressed,
        row: (context) => [
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 1'),
              style: flatButtonStyle,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Page 1',
              ),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 3'),
              style: flatButtonStyle,
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => Page3()));

                /// A good habit to get into. Refresh the screen again.
                /// In this case, to show the count may have changed.
                setState(() {});
              },
              child: const Text(
                'Page 3',
              ),
            ),
          ),
        ],
        column: (context) => [
          const Text("Has a 'data source' to save the count"),
        ],
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            key: const Key('Page 1 Counter'),
            style: flatButtonStyle,
            onPressed: Page1().onPressed,
            child: const Text('Page 1 Counter'),
          ),
        ],
      );
}
