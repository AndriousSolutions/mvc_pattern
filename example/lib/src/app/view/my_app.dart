// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// To be passed to the runApp() function.
/// This is the app's first StatefulWidget.
class MyApp extends AppStatefulWidgetMVC {
  MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  AppStateMVC createState() => _MyAppState();
}

///
class _MyAppState extends AppStateMVC<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();

  _MyAppState._()
      : super(
          controller: AppController(),
          controllers: [
            Controller(),
            AnotherController(),
            YetAnotherController(),
          ],

          /// Demonstrate passing an 'object' down the Widget tree much like
          /// in the Scoped Model
          object: 'Hello!',
        );
  static _MyAppState? _this;

  /// Optionally you can is the framework's buildApp() function
  /// instead of its build() function and allows for the InheritWidget feature
  @override
  Widget buildApp(BuildContext context) => MaterialApp(
        home: FutureBuilder<bool>(
            future: initAsync(),
            builder: (context, snapshot) {
              //
              if (snapshot.hasData) {
                //
                if (snapshot.data!) {
                  /// Key identifies the widget. New key? New widget!
                  /// Demonstrates how to explicitly 're-create' a State object
                  return Page1(key: UniqueKey());
                } else {
                  //
                  return const Text('Failed to startup');
                }
              } else if (snapshot.hasError) {
                //
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            }),
      );
}
