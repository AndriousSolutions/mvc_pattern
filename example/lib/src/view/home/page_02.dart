// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// The second page displayed in this app.
class Page2 extends StatefulWidget {
  /// Offer a means to trip an error
  Page2({Key? key, this.tripError})
      : con = Controller(),
        super(key: key);

  /// controller
  final Controller con;

  /// trip an error
  final bool? tripError;

  @override
  State createState() => _Page2State();

  /// This will 'rebuild' the InheritedWidget defined below
  /// and not call setState() function to instead initiate a rebuild.
  void onPressed() => con.incrementCounter();
}

/// This works with a separate 'data source'
/// It doesn't no what data source, but being so, the count is never reset to zero.
class _Page2State extends InheritedStateMVC<Page2, _Page02Inherited> {
  /// Define an InheritedWidget to be inserted above this Widget on the Widget tree.
  _Page2State()
      : super(inheritedBuilder: (child) => _Page02Inherited(child: child));

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

  /// Define the 'child' Widget that will be passed to the InheritedWidget above.
  @override
  Widget buildChild(BuildContext context) {
    final tripError = widget.tripError ?? false;

    if (tripError) {
      //ignore: only_throw_errors
      throw 'Pretend a error occurs here in this function.';
    }

    /// Comment this command out and the counter will not work.
    /// That's because this Widget is then no longer a dependency to the InheritedWidget above.
    dependOnInheritedWidget(context);

    /// Ignore BuildPage(). It's used only to highlight the other features in this page
    return BuildPage(
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
          onPressed: () {
            final state = con.ofState<Page1State>()!;
            state.onPressed();
          },
          child: const Text('Page 1 Counter'),
        ),
      ],
    );
  }
}

/// The inserted InheritedWidget that takes in the buildChild() Widget above.
class _Page02Inherited extends InheritedWidget {
  const _Page02Inherited({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(oldWidget) => true;
}
