// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

/// This separate class represents 'the Model' (the data) of the App.
class Model extends ModelMVC {
  factory Model([StateMVC? state]) => _this ??= Model._(state);
  Model._(StateMVC? state) : super(state);
  static Model? _this;

  int get counter => _counter;
  int _counter = 0;

  int incrementCounter() => ++_counter;

  int index = 0;
  final words = [
    'Hello There!',
    'How are you?',
    'Are you good?',
    'All the best.',
    'Bye for now.'
  ];

  String sayHello() {
    String say;
    if (index < words.length) {
      say = words[index];
      index++;
    } else {
      say = '';
    }
    return say;
  }
}
