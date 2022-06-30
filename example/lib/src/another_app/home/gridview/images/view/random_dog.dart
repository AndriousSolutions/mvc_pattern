// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///  This widget works with the free Dog API.
///

import 'package:example/src/another_app/controller.dart';

import 'package:example/src/another_app/view.dart';

///
class RandomDog extends StatefulWidget {
  ///
  const RandomDog({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RandomDogState();
}

class _RandomDogState extends ImageAPIStateMVC<RandomDog> {
  _RandomDogState()
      : super(
          controller: DogController(),
          uri: Uri(
            scheme: 'https',
            host: 'dog.ceo',
            path: 'api/breeds/image/random/1',
          ),
          message: 'message',
        );
}
