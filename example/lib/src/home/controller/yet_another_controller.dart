// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

class YetAnotherController extends ControllerMVC {
  /// It's a good practice to make Controllers using the Singleton pattern
  factory YetAnotherController() => _this ??= YetAnotherController._();
  YetAnotherController._() : super();
  static YetAnotherController? _this;
}
