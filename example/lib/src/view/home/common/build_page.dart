// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

/// Standard Counter Screen
///
class BuildPage extends StatelessWidget {
  const BuildPage({
    Key? key,
    required this.label,
    required this.count,
    required this.counter,
    this.column,
    required this.row,
    this.persistentFooterButtons,
  }) : super(key: key);

  final String label;
  final int count;
  final void Function() counter;
  final List<Widget> Function(BuildContext context)? column;
  final List<Widget> Function(BuildContext context) row;
  final List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Three-page example'),
        ),
        persistentFooterButtons: persistentFooterButtons,
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),
          onPressed: counter,
          child: const Icon(Icons.add),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text("You're on page:"),
            ),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                'You have pushed the button this many times:',
              ),
            ),
            Flexible(
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: row(context),
              ),
            ),
            if (column == null)
              const Flexible(child: SizedBox())
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: column!(context),
              ),
          ],
        ),
      );
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
