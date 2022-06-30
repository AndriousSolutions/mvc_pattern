// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This StatefulWidget works with the 'Dog' InheritedWidget
///

import 'package:example/src/another_app/controller.dart';

import 'package:example/src/another_app/view.dart';

/// This StatefulWidget stores an InheritedWidget
class InheritDog extends StatefulWidget {
  ///
  const InheritDog({Key? key, required this.child}) : super(key: key);

  ///
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _InheritDogState();
}

class _InheritDogState extends InheritedStateMVC<InheritDog, _DogInherited> {
  _InheritDogState()
      : super(
          controller: DogController(),
          inheritedBuilder: (child) => _DogInherited(child: child),
        );
  @override
  Widget buildChild(context) => widget.child!;
}

/// The InheritedWidget assigned 'dependent' child widgets.
class _DogInherited extends InheritedWidget {
  const _DogInherited({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(oldWidget) => true;
}
