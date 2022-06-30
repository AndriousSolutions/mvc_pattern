// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/model.dart';

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  int get count => _model.counter;

  // The Controller knows how to 'talk to' the Model and to the View (interface).
  void incrementCounter() {
    //
    _model.incrementCounter();

    /// Retrieve a particular State object. The rest is ignore if not at 'HomePage'
    final homeState = stateOf<HomePage>();

    /// If working with a particular State object and if divisible by 5
    if (homeState != null && _model.counter % 5 == 0) {
      //
      dataObject = _model.sayHello();
    }

    /// Just rebuild an InheritedWidget's dependencies.
    buildInherited();
  }

  /// Call the State object's setState() function to reflect the change.
  void onPressed() => setState(() => _model.incrementCounter());
}
