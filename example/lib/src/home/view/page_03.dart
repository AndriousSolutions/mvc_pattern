// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// The third page displayed in this app.
class Page3 extends StatefulWidget {
  Page3({Key? key})
      : con = Controller(),
        super(key: key);
  final Controller con;

  @override
  State createState() => _Page3State();

  /// Note, there is more than one way below to access the State object.
  void onPressed() {
//    final state = con.state as _Page3State;
    final state = con.stateOf<Page3>() as _Page3State;
    state.setState(() {});
    state.count++;
  }
}

class _Page3State extends StateMVC<Page3> {
  @override
  void initState() {
    // Register the controller with the StateMVC
    add(widget.con);
    // Allow for con.initState() to be called.
    super.initState();
  }

  int count = 0;

  @override
  Widget build(BuildContext context) => _buildPage3(
        count: count,
        newKey: () {
          rootState?.setState(() {});
        },
        counter: widget.onPressed,
        page1counter: () {
          Page1().onPressed();
        },
        page2counter: () {
          Page2().onPressed();
        },
      );

  /// Ignore this function. Study the features above instead.
  Widget _buildPage3({
    int count = 0,
    required void Function() counter,
    required void Function() newKey,
    required void Function() page1counter,
    required void Function() page2counter,
  }) =>
      BuildPage(
        label: '3',
        count: count,
        counter: counter,
        column: (_) => [
          Row(children: [
            const Flexible(child: SizedBox(width: 5)),
            Flexible(
              child: ElevatedButton(
                key: const Key('New Key'),
                onPressed: newKey,
                child: const Text('New Key for Page 1'),
              ),
            ),
            const Flexible(child: SizedBox(width: 5)),
            Flexible(
              child: ElevatedButton(
                key: const Key('Hello! example'),
                onPressed: () {
                  Navigator.push(
                      lastContext!,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const HomePage()));
                },
                child: const Text("'Hello!' example"),
              ),
            ),
          ]),
        ],
        row: (BuildContext context) => [
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 1'),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('Page 1'),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              key: const Key('Page 2'),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Page 2'),
            ),
          ),
        ],
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            key: const Key('Page 1 Counter'),
            onPressed: page1counter,
            child: const Text('Page 1 Counter'),
          ),
          ElevatedButton(
            key: const Key('Page 2 Counter'),
            onPressed: page2counter,
            child: const Text('Page 2 Counter'),
          ),
        ],
      );
}
