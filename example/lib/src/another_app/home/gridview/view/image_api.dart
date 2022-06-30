// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  Manages the API request for specifically 'image' public API's
///

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

///
class ImageAPIStateMVC<T extends StatefulWidget> extends StateMVC<T>
    implements ImageAPIState {
  ///
  ImageAPIStateMVC({
    required this.uri,
    this.message,
    ControllerMVC? controller,
  }) : super(controller) {
    //
    final keyId = add(ImageAPIController());
    // Retrieve the Controller by its unique id.
    _con = controllerById(keyId) as ImageAPIController;
    // or Simply by its type.
    _con = controllerByType<ImageAPIController>()!;
  }

  ///
  @override
  final Uri? uri;

  ///
  @override
  final String? message;

  late ImageAPIController _con;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildWidget(context) {
    controller?.dependOnInheritedWidget(context);
    return GestureDetector(
      onTap: _con.onTap,
      onDoubleTap: _con.onTap,
      child: Card(
        child: _con.image ?? const SizedBox(),
      ),
    );
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;
}

///
abstract class ImageAPIState {
  ///
  ImageAPIState({required this.uri, required this.message});

  ///
  final Uri? uri;

  ///
  final String? message;
}
