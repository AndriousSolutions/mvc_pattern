// // Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'package:flutter_test/flutter_test.dart' show expect, isInstanceOf;
//
// //ignore: avoid_relative_lib_imports
// import '../example/lib/src/home/controller/another_controller.dart';
//
// //ignore: avoid_relative_lib_imports
// import '../example/lib/src/home/controller/controller.dart';
//
// //ignore: avoid_relative_lib_imports
// import '../example/lib/src/view.dart' show ControllerMVC, StateMVC;
//
// void testsController(StateMVC? stateObj) {
//   //
//   expect(stateObj, isInstanceOf<StateMVC>());
//
//   /// Returns the unique identifier assigned to the Controller object.
//   /// Unnecessary. Merely demonstrating an alternative to 'adding' a
//   /// Controller object to a StatMVC object so to use its properties and functions.
//   /// It, in fact, won't be added to the Set.
//   var conId = stateObj?.add(Controller() as ControllerMVC);
//
//   expect(conId, isInstanceOf<String>(), reason: 'The unique key identifier.');
//
//   stateObj?.addList([Controller() as ControllerMVC]);
//
//   /// Another way to retrieve its Controller from a list of Controllers
//   /// Retrieve it by 'type'
//   /// This controller exists but not with this State object
//   /// but with the AppMVC (the App's State object)
//   final appController = stateObj?.controllerByType<AnotherController>();
//
//   expect(appController, isInstanceOf<AnotherController>());
//
//   /// This Controller will be found in this State object's listing.
//   var conObj = stateObj?.controllerByType<Controller>();
//
//   expect(conObj, isInstanceOf<Controller>());
//
//   conId = conObj?.keyId;
//
//   /// Another way to retrieve its Controller from a list of Controllers
//   /// Retrieve it by its key id Note the casting.
//   /// The function controllerById returns an object of type ControllerMVC.
//   conObj = stateObj?.controllerById(conId!) as Controller?;
//
//   expect(conObj, isInstanceOf<Controller>());
//
//   /// Return a List of Controllers specified by key id.
//   final listCons = conObj?.listControllers([conId!]);
//
//   expect(listCons, isInstanceOf<List<ControllerMVC?>>());
//
//   /// Only when the [StateMVC] object is first created.
//   conObj?.initState();
//
//   /// The framework calls this method when removed from the widget tree.
//   conObj?.deactivate();
//
//   /// Called during development whenever there's a hot reload.
//   conObj?.reassemble();
//
//   /// Allows you to call 'setState' from the 'current' the State object.
//   conObj?.setState(() {});
//
//   /// Allows you to call 'setState' from the 'current' the State object.
//   conObj?.refresh();
//
//   /// Allows you to call 'setState' from the 'current' the State object.
//   conObj?.rebuild();
//
//   /// Allows you to call 'setState' from the 'current' the State object.
//   conObj?.notifyListeners();
//
//   /// Return a 'copy' of the Set of State objects.
//   final Set<StateMVC>? states = conObj?.states;
//
//   expect(states, isInstanceOf<Set<StateMVC>>());
// }
