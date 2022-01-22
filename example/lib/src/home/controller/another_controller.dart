// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

class AnotherController extends ControllerMVC with AppControllerMVC {
  /// It's a good practice to make Controllers using the Singleton pattern
  factory AnotherController() => _this ??= AnotherController._();
  AnotherController._() : super();
  static AnotherController? _this;

  /// Associate this Controller to the specified State object
  /// to use that State object's functions and features.
  /// Returns that State object's unique identifier.
  @override
  String addState(StateMVC? state) => super.addState(state);

  /// The current StateMVC object.
  @override
  StateMVC? get state => super.state;

  /// Provide the setState() function to external actors
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  /// Allows external classes to 'refresh' or 'rebuild' the widget tree.
  @override
  void refresh() => super.refresh();

  /// Allow for a more accurate description
  @override
  void rebuild() => super.rebuild();

  /// For those accustom to the 'Provider' approach.
  @override
  void notifyListeners() => super.notifyListeners();

  /// Retrieve the State object by type
  /// Returns null if not found
  @override
  T? ofState<T extends State>() => super.ofState<T>();

  /// The framework will call this method exactly once.
  /// Only when the [StateMVC] object is first created.
  @override
  void initState() => super.initState();

  /// Called whenever its [StateMVC] object is placed in the 'background.'
  @override
  void deactivate() => super.deactivate();

  /// Called when this [StateMVC] object is itself disposed of.
  @override
  void dispose() => super.dispose();

  /// Override this method to respond when the [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) => didUpdateWidget(oldWidget);

  /// Called when this [StateMVC] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget is a dependency of
  /// [InheritedWidget].
  @override
  void didChangeDependencies() => super.didChangeDependencies();

  /// Called whenever the application is reassembled during hot reload.
  @override
  void reassemble() => super.reassemble();

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async => false;

  /// Called when app pushes a new route onto the navigator.
  @override
  Future<bool> didPushRoute(String route) async => false;

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      didPushRoute(routeInformation.location!);

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() => super.didChangeMetrics();

  /// Called when the platform's text sizes in the application.
  @override
  void didChangeTextScaleFactor() => super.didChangeTextScaleFactor();

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() => super.didChangePlatformBrightness();

  /// Called when the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) => didChangeLocale(locale);

  /// Called when the system puts the app in the background or
  /// returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() => super.didHaveMemoryPressure();

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() => didChangeAccessibilityFeatures();
}
