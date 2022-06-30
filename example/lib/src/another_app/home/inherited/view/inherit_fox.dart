// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This StatefulWidget works with the Fox InheritedWidget.
///

import 'package:example/src/another_app/controller.dart';

import 'package:example/src/another_app/view.dart';

/// This StatefulWidget stores an InheritedWidget
class InheritFox extends StatefulWidget {
  ///
  const InheritFox({Key? key, required this.child}) : super(key: key);

  ///
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _InheritFoxState();
}

class _InheritFoxState extends InheritedStateMVC<InheritFox, _FoxInherited> {
  _InheritFoxState()
      : super(
          controller: FoxController(),
          inheritedBuilder: (child) => _FoxInherited(child: child),
        );
  @override
  Widget buildChild(context) => widget.child!;
}

/// The InheritedWidget assigned 'dependent' child widgets.
class _FoxInherited extends InheritedWidget {
  const _FoxInherited({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(oldWidget) => true;
}
