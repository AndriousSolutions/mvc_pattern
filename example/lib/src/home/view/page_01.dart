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
  State createState() => _Page1State();

  void onPressed() {
    //
    final state = con.ofState<_Page1State>()!;

    state.setState(() {
      state.count++;
    });
  }
}

class _Page1State extends StateMVC<Page1> {
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

  @override
  Widget build(_) {
//    inheritWidget(context);
    return buildPage1(
        count: count,
        counter: () {
          count++;
          con.setState(() {});
//          inheritBuild();
        });
  }
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
