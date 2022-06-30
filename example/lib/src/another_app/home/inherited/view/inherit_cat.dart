// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Stores the InheritedWidget used to update the Cat images.
///

import 'package:example/src/another_app/controller.dart';

import 'package:example/src/another_app/view.dart';

/// This StatefulWidget stores an InheritedWidget
class InheritCat extends StatefulWidget {
  ///
  const InheritCat({Key? key, required this.child}) : super(key: key);

  ///
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _InheritCatState();
}

class _InheritCatState extends InheritedStateMVC<InheritCat, _CatInherited> {
  _InheritCatState()
      : super(
          controller: CatController(),
          inheritedBuilder: (child) => _CatInherited(child: child),
        );
  @override
  Widget buildChild(context) => widget.child!;
}

/// The InheritedWidget assigned 'dependent' child widgets.
class _CatInherited extends InheritedWidget {
  const _CatInherited({Key? key, required Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(oldWidget) => true;
}
