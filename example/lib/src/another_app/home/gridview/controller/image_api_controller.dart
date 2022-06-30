// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  The 'Image' State Object Controller.
///

import 'dart:async';

import 'dart:convert' show json;

import 'package:http/http.dart' as http;

import 'package:example/src/view.dart';

import 'package:example/src/another_app/home/gridview/view.dart';

/// This is the 'image API' State Object Controller.
class ImageAPIController extends ControllerMVC {
  /// Not a factory constructor and so multiple instances of this class is possible.
  ImageAPIController() : super();

  /// The List of data returned by the API.
  List<String> _data = [];

  /// The resulting image from the API.
  Image? image;

  ///
  void onTap() => state?.setState(() {});

  /// The number of images loading using this class.
  static int imageCount = 0;

  /// The number of images currently loading
  static int loadingCount = 0;

  /// Contains all the asynchronous operations that must complete before proceeding.
  @override
  Future<bool> initAsync() async {
    // Call the API
    _data = await _getURIData();

    if (_data.isNotEmpty) {
      image = Image.network(_data[0]);
      final imageStream = image!.image.resolve(const ImageConfiguration());
      final completer = Completer<void>();
      imageCount++;
      loadingCount++;
      final listener = ImageStreamListener((ImageInfo info, bool syncCall) {
        // Error if called again and so test if completed.
        if (!completer.isCompleted) {
          completer.complete();
          loadingCount--;
          if (loadingCount == 0) {
            /// All the image(s) have completed loading.
          }
        }
      });
      imageStream.addListener(listener);
      await completer.future;
      // No need anymore. Best to remove in case triggered again.
      imageStream.removeListener(listener);
    }
    return _data.isNotEmpty;
  }

  /// Retrieve the data
  Future<List<String>> _getURIData() async {
    //
    final List<String> data = [];

    // Cast to the abstract class with the two properties.
    final _api = state as ImageAPIState;

    final message = _api.message;

    final uri = _api.uri;

    if (uri != null) {
      //
      final http.Response response = await http.get(uri);

      final jsonResponse = json.decode(response.body);

      dynamic dataItem;

      if (jsonResponse is List) {
        int index;
        if (message == null ||
            message.isEmpty ||
            double.tryParse(message) == null) {
          index = 0;
        } else {
          index = int.parse(message);
          if (index < 0 || index >= jsonResponse.length) {
            index = 0;
          }
        }
        dataItem = jsonResponse[index];
      } else {
        if (message == null || message.isEmpty) {
          dataItem = jsonResponse.entries.first;
        } else {
          dataItem = jsonResponse[message];
        }
      }

      switch (dataItem.runtimeType) {
        case List:
          dataItem.forEach(data.add);
          break;
        case String:
          data.add(dataItem);
          break;
      }
    }
    return data;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;
}
