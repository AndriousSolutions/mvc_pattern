// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///
///

import 'package:example/src/controller.dart';

/// This SOC is associated with the Bird images and works with
/// InheritBird StatefulWidget and the InheritedWidget, _BirdInherited
class BirdController extends InheritController {
  ///
  factory BirdController() => _this ??= BirdController._();
  BirdController._();
  static BirdController? _this;
}
