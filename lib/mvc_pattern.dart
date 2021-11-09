/// This library contains the classes necessary to develop apps using the MVC design pattern
/// separating the app's 'interface' from its 'business logic' and from its 'data source' if any.
///
/// Code samples can be found in the following links:
/// https://github.com/AndriousSolutions/mvc_pattern/tree/master/test
/// https://github.com/AndriousSolutions/mvc_pattern/blob/master/example/lib/main.dart
///
/// https://github.com/AndriousSolutions/mvc_pattern
///
library mvc_pattern;

/// Note: This license has also been called the "Simplified BSD License" and the "FreeBSD License".
/// See also the 2-clause BSD License.
///
/// Copyright 2018 www.andrioussolutions.com
///
/// Redistribution and use in source and binary forms, with or without modification,
/// are permitted provided that the following conditions are met:
///
/// 1. Redistributions of source code must retain the above copyright notice,
/// this list of conditions and the following disclaimer.
///
/// 2. Redistributions in binary form must reproduce the above copyright notice,
/// this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
/// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
/// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
/// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
/// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
///
/// NOTE: Full overview of mvc_pattern package can be found in this article:
/// https://medium.com/follow-flutter/flutter-mvc-at-last-275a0dc1e730

import 'dart:async' show Future;

import 'dart:math' show Random;

import 'package:flutter/foundation.dart' show FlutterExceptionHandler;

import 'package:flutter/material.dart'
    show
        AppLifecycleState,
        BuildContext,
        FlutterError,
        FlutterErrorDetails,
        WidgetsFlutterBinding,
        InheritedElement,
        InheritedWidget,
        Key,
        Locale,
        mustCallSuper,
        Navigator,
        State,
        StatefulWidget,
        StatelessWidget,
        VoidCallback,
        Widget,
        WidgetsApp,
        WidgetsBinding,
        WidgetsBindingObserver,
        mustCallSuper,
        protected;

import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;

/// This class is to be concerned with the data
/// It is accessed by the Controller but can call setState() as well.
class ModelMVC extends StateSetter {
  //
  ModelMVC([StateMVC? state]) : super() {
    _pushState(state);
  }
}

/// Your 'working' class most concerned with the app's functionality.
/// Add it to a 'StateMVC' object to associate it with that State object.
class ControllerMVC extends StateSetter with StateListener {
  //
  ControllerMVC([StateMVC? state]) : super() {
    addState(state);
  }

  /// Associate this Controller to the specified State object
  /// to use that State object's functions and features.
  /// Returns that State object's unique identifier.
  String addState(StateMVC? state) {
    if (state == null) {
      return '';
    }
    if (state.add(this).isNotEmpty) {
      return state.keyId;
    } else {
      return '';
    }
  }

  /// The current StateMVC object.
  StateMVC? get state => _stateMVC;

  /// Return a List of Controllers specified by key id.
  List<ControllerMVC?> listControllers(List<String> keys) =>
      _stateMVC!.listControllers(keys);

  /// Retrieve the 'before' listener by its unique key.
  StateListener? beforeListener(String key) => _stateMVC?.beforeListener(key);

  /// Retrieve the 'after' listener by its unique key.
  StateListener? afterListener(String key) => _stateMVC?.afterListener(key);
}

/// Allows you to call 'setState' from the 'current' the State object.
class StateSetter with StateSets {
  /// Provide the setState() function to external actors
  void setState(VoidCallback fn) => _stateMVC?.setState(fn);

  /// Allows external classes to 'refresh' or 'rebuild' the widget tree.
  void refresh() => _stateMVC?.refresh();

  /// Allow for a more accurate description
  void rebuild() => refresh();

  /// For those accustom to the 'Provider' approach.
  void notifyListeners() => refresh();
}

/// Record in a Set any previous State objects
/// and the current State object being used.
mixin StateSets {
  StateMVC? _stateMVC;
  final Set<StateMVC> _stateMVCSet = {};
  bool _statePushed = false;

  /// Push the StateMVC object to a Set of such objects
  /// Internal use only: This connects the Controller to this View!
  @Deprecated('Too intrusive method to manages State objects.')
  bool pushState(StateMVC? state) => _pushState(state);

  bool _pushState(StateMVC? state) {
    if (state == null) {
      return false;
    }
    _statePushed = true;
    _stateMVC = state;
    return _stateMVCSet.add(state);
  }

  /// This removes the most recent StateMVC object added
  /// to the Set of StateMVC state objects.
  /// Primarily internal use only: This disconnects the Controller from that StateMVC object.
  bool _popState([StateMVC? state]) {
    bool pop;

    // Remove if the current state
    if (state != null && state == _stateMVC) {
      _statePushed = false;
      _stateMVCSet.remove(state);
    }

    // Another state object was already pushed onto the Set.
    if (_statePushed) {
      _statePushed = false;
      pop = false;
    } else {
      // Remove all that have been disposed of.
      _stateMVCSet.retainWhere((state) => state.mounted);

      if (_stateMVCSet.isEmpty) {
        //
        _stateMVC = null;
        pop = false;
      } else {
        //
        _stateMVC = _stateMVCSet.last;
        // A replacement was found.
        pop = true;
      }
    }
    return pop;
  }

  /// Retrieve the State object by type
  /// Returns null if not found
  T? ofState<T extends State>() {
    State? state;
    if (_stateMVCSet.isEmpty) {
      state = null;
    } else {
      final stateList = _stateMVCSet.toList(growable: false);
      try {
        state = stateList.firstWhere((item) => item is T);
      } catch (_) {
        state = null;
      }
    }
    // ignore: avoid_as
    return state == null ? null : state as T;
  }

  /// Return a 'copy' of the Set of State objects.
  Set<StateMVC> get states => Set.from(_stateMVCSet.whereType<StateMVC>());
}

/// Responsible for the event handling in all the Controllers, Listeners and Views.
mixin StateListener {
  // Assigned an unique key.
  String get keyId => _keyId;
  final String _keyId = Uuid().generateV4();

  /// The framework will call this method exactly once.
  /// Only when the [StateMVC] object is first created.
  @mustCallSuper
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  /// The framework calls this method whenever it removes this [StateMVC] object
  /// from the tree.
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  /// The framework calls this method when this [StateMVC] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [StateMVC] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).
  }

  // ignore: comment_references
  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  /// Called when a dependency of this [StateMVC] object changes.
  void didChangeDependencies() {
    /// Called when a dependency of this [State] object changes.
    ///
    /// For example, if the previous call to [build] referenced an
    /// [InheritedWidget] that later changed, the framework would call this
    /// method to notify this object about the change.
    ///
    /// This method is also called immediately after [initState]. It is safe to
    /// call [BuildContext.inheritFromWidgetOfExactType] from this method.
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  void reassemble() {
    /// Called whenever the application is reassembled during debugging, for
    /// example during hot reload.
    ///
    /// This method should rerun any initialization logic that depends on global
    /// state, for example, image loading from asset bundles (since the asset
    /// bundle may have changed).
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  ///
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification, for example by closing an active dialog
  /// box, and false otherwise. The [WidgetsApp] widget uses this
  /// mechanism to notify the [Navigator] widget that it should pop
  /// its current route if possible.
  ///
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  Future<bool> didPopRoute() async => true;

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  ///
  /// Observers are expected to return true if they were able to
  /// handle the notification. Observers are notified in registration
  /// order until one returns true.
  ///
  /// This method exposes the `pushRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  Future<bool> didPushRoute(String route) async => true;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  void didChangeMetrics() {
    /// Called when the application's dimensions change. For example,
    /// when a phone is rotated.
    ///
    /// In general, this is not overriden often as the layout system takes care of
    /// automatically recomputing the application geometry when the application
    /// size changes
    ///
    /// This method exposes notifications from [Window.onMetricsChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeMetrics() {
    ///     setState(() { _lastSize = ui.window.physicalSize; });
    ///   }
  }

  /// Called when the platform's text scale factor changes.
  void didChangeTextScaleFactor() {
    /// Called when the platform's text scale factor changes.
    ///
    /// This typically happens as the result of the user changing system
    /// preferences, and it should affect all of the text sizes in the
    /// application.
    ///
    /// This method exposes notifications from [Window.onTextScaleFactorChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeTextScaleFactor() {
    ///     setState(() { _lastTextScaleFactor = ui.window.textScaleFactor; });
    ///   }
  }

  /// {@macro on_platform_brightness_change}
  void didChangePlatformBrightness() {
    /// Brightness changed.
  }

  /// Called when the system tells the app that the user's locale has changed.
  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
  }

  /// Called when the system is running low on memory.
  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  /// Called when the system changes the set of active accessibility features.
  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].
  }
}

/// The State Object seen as the 'View of the State.'
/// Uses the mixins: WidgetsBindingObserver, _ControllerList, _StateListeners
abstract class StateMVC<T extends StatefulWidget> extends State<StatefulWidget>
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver,
        _ControllerListing,
        _StateListeners
    implements
        StateListener {
  /// With an optional Controller parameter, this constructor imposes its own Error Handler.
  StateMVC([this._controller]) : currentErrorFunc = FlutterError.onError {
    /// If a tester is running. Don't switch out its error handler.
    /// WidgetsBinding.instance is WidgetsFlutterBinding
    if (WidgetsBinding.instance == null ||
        WidgetsBinding.instance is WidgetsFlutterBinding) {
      /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
      FlutterError.onError = onError;
    } else {
      _inTester = WidgetsBinding.instance is TestWidgetsFlutterBinding;
    }

    /// IMPORTANT! Assign itself to stateView before adding any Controller. -gp
    /// Any subsequent calls to add() will be assigned, stateMVC.
    _stateMVC = this;
    add(_controller);
  }
  ControllerMVC? _controller;

  /// The View!
  @override
  Widget build(BuildContext context);

  /// Save the current Error Handler.
  final FlutterExceptionHandler? currentErrorFunc;

  /// You need to be able access the widget.
  @override
  // ignore: avoid_as
  T get widget => super.widget as T;

  /// Provide the 'main' controller to this 'State View.'
  /// If _controller == null, get the 'first assigned' controller.
  ControllerMVC? get controller => _controller ??= firstCon;

  /// Retrieve a Controller by its a unique String identifier.
  ControllerMVC? controllerById(String keyId) => super._con(keyId);

  /// Add a specific Controller to this View.
  /// Returns the Controller's unique String identifier.
  @override
  String add(ControllerMVC? c) {
    if (c != null) {
      /// It may have been a listener. Can't be both.
      removeListener(c);
    }

    return super.add(c);
  }

  /// Add a list of 'Controllers' to be associated with this StatMVC object.
  @override
  void addList(List<ControllerMVC>? list) {
    if (list == null) {
      return;
    }
    // Associate a list of 'Controllers' to this StateMVC object at one time.
    return super.addList(list);
  }

  /// The unique key identifier for this State object.
  @override
  String get keyId => _keyId;

  /// Contains the unique String identifier.
  @override
  final String _keyId = Uuid().generateV4();

  /// Retrieve a Controller in the widget tree by type.
  //  T controllerByType<T extends ControllerMVC>(
//      [BuildContext context, bool listen = true]) {
//    T con;
//    if (context != null && listen) {
//      _InheritedMVC<Object> w =
//          context.dependOnInheritedWidgetOfExactType<_InheritedMVC<Object>>();
//      con = w?.object;
//    }
//    return con ?? _cons[_type<T>()];
//  }

  /// Retrieve a Controller in the MVC framework by type.
  U? controllerByType<U extends ControllerMVC?>() {
    // Look in this State objects list of Controllers.  Maybe not?
    // ignore: avoid_as
    U? con = _cons[_type<U>()] as U?;
    // ignore: avoid_as
    return con ??= AppStatefulWidgetMVC._controllers[_type<U>()] as U?;
  }

  Type _type<U>() => U;

  /// May be set false to prevent unnecessary 'rebuilds'.
  static bool _rebuildAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _rebuildRequested = false;

  /// A flag indicating initAsync was called
  bool futureBuilt = false;

  /// Running in a tester instead of production.
  bool _inTester = false;

  /// Supply the 'latest' StateMVC object from the widget tree.
  static T? of<T extends StateMVC>(BuildContext? context) {
    assert(context != null);
    return context!.findAncestorStateOfType<T>();
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateMVC] object is first created.
  @protected
  @override
  @mustCallSuper
  void initState() {
    assert(mounted, '${toString()} is not instantiated properly.');

    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    super.initState();

    /// Registers the given object as a binding observer. Binding
    /// observers are notified when various application events occur,
    /// for example when the system locale changes. Generally, one
    /// widget in the widget tree registers itself as a binding
    /// observer, and converts the system state into inherited widgets.
    WidgetsBinding.instance!.addObserver(this);

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.initState();
    }
    for (final con in _controllerList) {
      con.initState();
    }
    for (final listener in _afterList) {
      listener.initState();
    }
    _rebuildAllowed = true;
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  @protected
  @override
  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.deactivate();
    }
    for (final con in _beforeList) {
      con.deactivate();
    }
    for (final listener in _beforeList) {
      listener.deactivate();
    }
    super.deactivate();
    _rebuildAllowed = true;

    /// In some cases, if then reinserted back in another part of the tree
    /// the build is called, and so setState() is not necessary.
    _rebuildRequested = false;
  }

  /// The framework calls this method when this [StateMVC] object will never
  /// build again.
  @protected
  @override
  @mustCallSuper
  void dispose() {
    /// The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    // No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;

    for (final listener in _beforeList) {
      listener.dispose();
    }
    for (final con in _controllerList) {
      // This state's association is severed.
      con._popState(this);

      // Don't call its dispose if it's in other State objects.
      if (con._stateMVCSet.isEmpty) {
        con.dispose();
      }
    }
    _disposeControllerListing();
    for (final listener in _afterList) {
      listener.dispose();
    }
    _disposeStateEventList();

    // *In some cases, the setState() will be called again! gp
    _rebuildAllowed = true;

    // Unregisters the given observer.
    WidgetsBinding.instance!.removeObserver(this);

    // Remove any 'Controller' reference
    _controller = null;

    // Clear the list of Controllers.
    _cons.clear();

    // Return the original error routine.
    FlutterError.onError = currentErrorFunc;

    AppStatefulWidgetMVC._removeStateMVC(this);

    super.dispose();
  }

  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  @protected
  @override
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.

    /// No 'setState()' functions are allowed
    /// The framework always calls build after calling didUpdateWidget,
    /// which means any calls to setState in didUpdateWidget are redundant.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didUpdateWidget(oldWidget);
    }
    for (final con in _controllerList) {
      con.didUpdateWidget(oldWidget);
    }
    for (final listener in _afterList) {
      listener.didUpdateWidget(oldWidget);
    }
    super.didUpdateWidget(oldWidget);
    _rebuildAllowed = true;

    /// No 'setState()' functions are necessary
    _rebuildRequested = false;
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @protected
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeAppLifecycleState(state);
    }
    for (final con in _controllerList) {
      con.didChangeAppLifecycleState(state);
    }
    for (final listener in _afterList) {
      listener.didChangeAppLifecycleState(state);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  ///
  @protected
  @override
  @mustCallSuper
  Future<bool> didPopRoute() async {
    /// Observers are expected to return true if they were able to
    /// handle the notification, for example by closing an active dialog
    /// box, and false otherwise. The [WidgetsApp] widget uses this
    /// mechanism to notify the [Navigator] widget that it should pop
    /// its current route if possible.
    ///
    /// This method exposes the `popRoute` notification from
    /// [SystemChannels.navigation].
    ///
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      await listener.didPopRoute();
    }
    for (final con in _controllerList) {
      await con.didPopRoute();
    }
    for (final listener in _afterList) {
      await listener.didPopRoute();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
    // Return false to pop out
    return false;
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  ///
  @protected
  @override
  @mustCallSuper
  Future<bool> didPushRoute(String route) async {
    /// Observers are expected to return true if they were able to
    /// handle the notification. Observers are notified in registration
    /// order until one returns true.
    ///
    /// This method exposes the `pushRoute` notification from

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      await listener.didPushRoute(route);
    }
    for (final con in _controllerList) {
      await con.didPushRoute(route);
    }
    for (final listener in _afterList) {
      await listener.didPushRoute(route);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
    return false;
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @protected
  @override
  @mustCallSuper
  void didChangeMetrics() {
    /// In general, this is not overridden often as the layout system takes care of
    /// automatically recomputing the application geometry when the application
    /// size changes
    ///
    /// This method exposes notifications from [Window.onMetricsChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeMetrics() {
    ///     setState(() { _lastSize = ui.window.physicalSize; });
    ///   }

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeMetrics();
    }
    for (final con in _controllerList) {
      con.didChangeMetrics();
    }
    for (final listener in _afterList) {
      listener.didChangeMetrics();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the platform's text scale factor changes.
  @protected
  @override
  @mustCallSuper
  void didChangeTextScaleFactor() {
    ///
    /// This typically happens as the result of the user changing system
    /// preferences, and it should affect all of the text sizes in the
    /// application.
    ///
    /// This method exposes notifications from [Window.onTextScaleFactorChanged].
    /// See sample code below. No need to call super if you override.
    ///   @override
    ///   void didChangeTextScaleFactor() {
    ///     setState(() { _lastTextScaleFactor = ui.window.textScaleFactor; });
    ///   }

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeTextScaleFactor();
    }
    for (final con in _controllerList) {
      con.didChangeTextScaleFactor();
    }
    for (final listener in _afterList) {
      listener.didChangeTextScaleFactor();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the platform brightness changes.
  @protected
  @override
  @mustCallSuper
  void didChangePlatformBrightness() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangePlatformBrightness();
    }
    for (final con in _controllerList) {
      con.didChangePlatformBrightness();
    }
    for (final listener in _afterList) {
      listener.didChangePlatformBrightness();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  @protected
  @mustCallSuper
  @override
  void didChangeLocale(Locale locale) {
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeLocale(locale);
    }
    for (final con in _controllerList) {
      con.didChangeLocale(locale);
    }
    for (final listener in _afterList) {
      listener.didChangeLocale(locale);
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the system is running low on memory.
  @protected
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didHaveMemoryPressure();
    }
    for (final con in _controllerList) {
      con.didHaveMemoryPressure();
    }
    for (final listener in _afterList) {
      listener.didHaveMemoryPressure();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the system changes the set of currently active accessibility
  /// features.
  @protected
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    for (final listener in _beforeList) {
      listener.didChangeAccessibilityFeatures();
    }
    for (final con in _controllerList) {
      con.didChangeAccessibilityFeatures();
    }
    for (final listener in _afterList) {
      listener.didChangeAccessibilityFeatures();
    }
    _rebuildAllowed = true;
    if (_rebuildRequested || _inTester) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// A flag indicating this is the very first build.
  bool _firstBuild = true;

  /// Called when a dependency of this [State] object changes.
  /// This method is also called immediately after [initState].
  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.didChangeDependencies();
    }
    for (final con in _controllerList) {
      con.didChangeDependencies();
    }
    for (final listener in _afterList) {
      listener.didChangeDependencies();
    }
    super.didChangeDependencies();
    _rebuildAllowed = true;
    if (_rebuildRequested && !_firstBuild) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }

    /// Not the first build now.
    _firstBuild = false;
  }

  /// During development, if a hot reload occurs, the reassemble method is called.
  /// This provides an opportunity to reinitialize any data that was prepared
  /// in the initState method.
  @protected
  @override
  @mustCallSuper
  void reassemble() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      listener.reassemble();
    }
    for (final con in _controllerList) {
      con.reassemble();
    }
    for (final listener in _afterList) {
      listener.reassemble();
    }
    super.reassemble();
    _rebuildAllowed = true;

    /// No 'setState()' function is necessary
    /// The framework always calls build with a hot reload.
    _rebuildRequested = false;
  }

  /// Allows 'external' routines can call this function.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  @override
  void setState(VoidCallback fn) {
    if (_rebuildAllowed) {
      _rebuildAllowed = false;

      // Don't bother if the State object is disposed of.
      if (mounted) {
        /// Refresh the interface by 'rebuilding' the Widget Tree
        /// Call the State object's setState() function.
        super.setState(fn);
      }
      // else {
      //   // Don't recall why this if statement if not mounted?
      //   if (WidgetsBinding.instance == null ||
      //       WidgetsBinding.instance is WidgetsFlutterBinding) {
      //     /// Refresh the interface by 'rebuilding' the Widget Tree
      //     super.setState(fn);
      //   }
      // }
      _rebuildAllowed = true;
    } else {
      /// Can't rebuild at this moment but at least make the request.
      _rebuildRequested = true;
    }
  }

  /// Allows the user to call setState() within the Controller.
  void refresh() => setState(() {});

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each StateMVC object.
  // details.exception, details.stack
  @protected
  void onError(FlutterErrorDetails details) => currentErrorFunc!(details);
}

/// Add, List, and Remove Listeners.
mixin _StateListeners {
  List<StateListener> get _beforeList => _listenersBefore.toList();
  List<StateListener> beforeList(List<String> keys) {
    return _getList(keys, _listenersBefore);
  }

  final Set<StateListener> _listenersBefore = {};

  List<StateListener> get _afterList => _listenersAfter.toList();
  List<StateListener> afterList(List<String> keys) {
    return _getList(keys, _listenersAfter);
  }

  List<StateListener> _getList(List<String>? keys, Set<StateListener> set) {
    final List<StateListener> list = [];
    if (keys == null || keys.isEmpty) {
      return list;
    }
    for (final listener in set) {
      for (final key in keys) {
        if (listener._keyId == key) {
          list.add(listener);
          keys.remove(key);
          break;
        }
      }
    }
    return list;
  }

  final Set<StateListener> _listenersAfter = {};

  /// Add a listener fired 'before' the main controller runs.
  bool addBeforeListener(StateListener listener) =>
      _listenersBefore.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addAfterListener(StateListener listener) =>
      _listenersAfter.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addListener(StateListener listener) => addAfterListener(listener);

  /// Removes the specified listener.
  bool removeListener(StateListener listener) {
    bool removed = _listenersBefore.remove(listener);
    if (_listenersAfter.remove(listener)) {
      removed = true;
    }
    return removed;
  }

  /// Returns true of the listener specified is already added.
  bool beforeContains(StateListener listener) =>
      _listenersBefore.contains(listener);

  /// Returns true of the listener specified is already added.
  bool afterContains(StateListener listener) =>
      _listenersAfter.contains(listener);

  /// Returns the specified 'before' listener.
  StateListener? beforeListener(String key) =>
      _getStateEvents(key, _listenersBefore);

  /// Returns the specified 'after' listener.
  StateListener? afterListener(String key) =>
      _getStateEvents(key, _listenersAfter);

  StateListener? _getStateEvents(String? key, Set<StateListener> set) {
    StateListener? se;
    if (key == null || key.isEmpty) {
      return se;
    }
    for (final listener in set) {
      if (listener._keyId == key) {
        se = listener;
        break;
      }
    }
    return se;
  }

  void _disposeStateEventList() {
    _listenersBefore.clear();
    _listenersAfter.clear();
  }
}

/// Manages the number of 'Controllers' associated with this
/// StateMVC object at any one time during the App's lifecycle.
mixin _ControllerListing {
  StateMVC? _stateMVC;

  // Keep it private to allow subclasses to use 'con.'
  ControllerMVC? _con(String? keyId) {
    if (keyId == null || keyId.isEmpty) {
      return null;
    }
    return _map[keyId];
  }

  /// Associate a list of 'Controllers' to this StateMVC object at one time.
  void addList(List<ControllerMVC> list) => list.forEach(add);

  /// Returns the list of 'Controllers' associated with this StateMVC object.
  List<ControllerMVC?> listControllers(List<String> keys) =>
      _controllers(keys).values.toList();

  /// Never supply a public list of Controllers. User must know the key identifier(s).
  List<ControllerMVC> get _controllerList => _asList; //_controllers.asList;

  /// Returns a specific 'Controller' by looking up its unique 'key' identifier.
  Map<String, ControllerMVC?> _controllers(List<String> keys) {
    final Map<String, ControllerMVC?> controllers = {};

    for (final key in keys) {
      controllers[key] = map[key];
    }
    return controllers;
  }

  final Map<String, ControllerMVC> _map = {};

  /// Returns a Map containing all the 'Controllers' associated with this
  /// StateMVC object each with their unique 'key' identifier.
  Map<String, ControllerMVC> get map => _map;

  List<ControllerMVC> get _asList => _map.values.toList();

  /// Add a 'Controller' to then associate it to this
  /// particular StateMVC object. Returns the Controller's
  /// unique 'key' identifier.
  String add(ControllerMVC? con) {
    String keyId;

    if (con == null) {
      keyId = '';
    } else {
      /// This connects the Controller to this View!
      con._pushState(_stateMVC);

      /// It's already there?! Return its key.
      keyId = (contains(con)) ? con._keyId : addConId(con);

      if (!_cons.containsValue(con)) {
        _cons.addAll({con.runtimeType: con});
      }
    }

    /// Collects this StateMVC object to the 'main list' of such objects.
    AppStatefulWidgetMVC._addStateMVC(this as StateMVC);

    return keyId;
  }

  /// Remove a specific associated 'Controller' from this StateMVC object
  /// by using its unique 'key' identifier.
  bool remove(String keyId) {
    final con = _map[keyId];
    final there = con != null;
    if (there) {
      con!._popState(_stateMVC);
      _map.remove(keyId);
    }
    return there;
  }

  /// Returns 'the first' Controller associated with this StateMVC object.
  ControllerMVC? get firstCon => _asList.first;

  /// Returns true if the specified 'Controller' is associated with this StateMVC object.
  bool contains(ControllerMVC con) => _map.containsValue(con);

  void _disposeControllerListing() => _map.clear();

  /// Adds a 'Controller' to be associated with this StateMVC object
  /// and returns Controller's the unique 'key' identifier assigned to it.
  String addConId(ControllerMVC con) {
    final keyId = con.keyId; //_addKeyId(con);
    _map[keyId] = con;
    return keyId;
  }

  final Map<Type, ControllerMVC> _cons = {};
}

/// Main or first class to pass to the 'main.dart' file's runApp() function.
/// AppStatefulWidget is its subclass.
abstract class AppStatefulWidgetMVC extends StatefulWidget {
  const AppStatefulWidgetMVC({Key? key, this.con}) : super(key: key);

  final AppControllerMVC? con;

  /// You create the App's State object.
  @override
  AppStateMVC createState();

  /// Get the controller if any
  ControllerMVC? get controller => con;

  /// Most recent BuildContext/Element
  BuildContext? get context {
    BuildContext? context;
    while (_states.isNotEmpty) {
      try {
        context = _states.last.values.last.context;
        break;
      } catch (ex) {
        if (ex is FlutterError && ex.message.contains('unmounted')) {
          _states.remove(_states.last);
        } else {
          break;
        }
      }
    }
    return context;
  }

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  @mustCallSuper
  @Deprecated('No need to replace the initState() function. Use initState()')
  void initApp() => con?.initApp();

  /// Called in State object.
  /// Called when this [State] object will never build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @mustCallSuper
  void dispose() {
    _controllers.clear();
    _states.clear();
  }

  static final Map<Type, Object> _controllers = {};

  static final Set<Map<String, StateMVC>> _states = {};

  //todo: onError() can't be called in the StatefulWidget
  // /// Override if you like to customize your error handling.
  // void onError(FlutterErrorDetails details) {
  //   if (con != null) {
  //     con!.onError(details);
  //   } else {
  //     // Call the State object's Exception handler
  //     appState.currentErrorFunc!(details);
  //   }
  // }

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  static bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Returns a StateView object using a unique String identifier.
  // There's a better way. Just too tired now.
  static StateMVC? getState(String keyId) {
    StateMVC? sv;
    for (final map in _states) {
      if (map.containsKey(keyId)) {
        sv = map[keyId];
        break;
      }
    }
    return sv;
  }

  /// Returns a Map of StateView objects using unique String identifiers.
  static Map<String, StateMVC> getStates(List<String> keys) {
    final Map<String, StateMVC> map = {};
    for (final key in keys) {
      final sv = getState(key);
      if (sv != null) {
        map[key] = sv;
      }
    }
    return map;
  }

  /// Returns a List of StateView objects using unique String identifiers.
  static List<StateMVC> listStates(List<String> keys) {
    return getStates(keys).values.toList();
  }

  /// This is 'privatized' as it is an critical method and not for public access.
  /// This contains the 'main list' of StateMVC objects present in the app!
  static void _addStateMVC(StateMVC state) {
    final Map<String, StateMVC> map = {};
    map[state._keyId] = state;
    _states.add(map);
    for (final con in state._controllerList) {
      _controllers.addAll({con.runtimeType: con});
    }
  }

  static bool _removeStateMVC(StateMVC? state) {
    var removed = state != null;
    if (removed) {
      final int length = _states.length;
      _states.removeWhere((element) => state!._keyId == element.keys.first);
      removed = _states.length < length;
    }
    return removed;
  }
}

/// The StatMVC object at the 'app level.' Used to effect the whole app.
abstract class AppStateMVC<T extends AppStatefulWidgetMVC>
    extends _AppStateMVC<T> {
  //
  AppStateMVC({
    ControllerMVC? controller,
    this.controllers,
    Object? object,
  }) : super(controller) {
    _dataObj = object;
    addList(controllers?.toList());
  }
  final List<ControllerMVC>? controllers;

  /// This is of type Object allowing you
  /// to propagate any class object you wish down the widget tree.
  Object? get dataObject => _dataObj;
  Object? _dataObj;

  set dataObject(Object? object) {
    // Never explicitly set to null
    if (object != null) {
      //
      _dataObj = object;
      // If there's a SetState class out there being used.
      if (_setStates && StateMVC._rebuildAllowed) {
        // Call inherited widget to 'rebuild' the dependencies
        _InheritedMVC.setState(() {});
      }
    }
  }

  /// Implement this function to compose the App's View.
  /// Override to impose your own WidgetsApp (like CupertinoApp or MaterialApp)
  Widget buildApp(BuildContext context);

  /// The App's View's build function calls the
  /// abstract function, buildApp, but also implements a
  /// InheritedWidget allowing for spontaneous rebuilds of dependencies.
  @override
  Widget build(BuildContext context) =>
      _InheritedMVC(state: this, child: buildApp(context));

  /// Link a widget to InheritedWidget
  ///
  static void inheritWidget(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedWidget>();

  /// Call the build() functions of all the widgets 'linked' to the Inherited widget.
  void setStatesInherited([Object? object]) {
    dataObject = object;
    _buildInherited = true;
    _InheritedMVC.setState(() {});
  }

  /// Calls the State object's setState() function if not
  /// already in the SetState.builder() function (see class SetState below).
  @override
  void setState(VoidCallback fn) {
    if (!_inBuilder) {
      super.setState(fn);
    }
  }

  /// Calls the State object's refresh() function if not
  /// already in the SetState.builder() function (see class SetState below).
  /// The refresh() function is just another name used to call
  /// the State object's setState() function.
  @override
  void refresh() {
    if (!_inBuilder) {
      super.refresh();
    }
  }

  /// Catch and explicitly handle the error.
  void catchError(Exception? ex) {
    if (ex == null) {
      return;
    }

    /// If a tester is running. Don't handle the error.
    if (WidgetsBinding.instance == null ||
        WidgetsBinding.instance is WidgetsFlutterBinding) {
      FlutterError.onError!(FlutterErrorDetails(exception: ex));
    }
  }

  bool _buildInherited = false;
  bool _inBuilder = false;
  bool _setStates = false;
}

/// The App's first State object.
/// It brings in the first State object
abstract class _AppStateMVC<T extends AppStatefulWidgetMVC>
    extends StateMVC<T> {
  //
  _AppStateMVC(ControllerMVC? con) : super(con);

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @mustCallSuper
  Future<bool> initAsync() async {
    /// It's been done. Don't run again.
    if (futureBuilt) {
      return futureBuilt;
    }
    futureBuilt = true;

    /// This will call any and all Controllers that need asynchronous operations
    /// completed before continuing.
    /// No 'setState()' functions are allowed to fully function at this point.
    StateMVC._rebuildAllowed = false;

    for (final con in _controllerList) {
      if (con is! AppControllerMVC) {
        continue;
      }
      futureBuilt = await con.initAsync();
      // Don't continue if there's an error.
      if (!futureBuilt) {
        break;
      }
    }
    StateMVC._rebuildAllowed = true;
    // Set the flag
    return futureBuilt;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  bool onAsyncError(FlutterErrorDetails details) {
    /// This will call any and all Controllers
    /// that may have ran asynchronous operations.
    bool handled = true;

    /// No 'setState()' functions are allowed to fully function at this point.
    StateMVC._rebuildAllowed = false;
    for (final con in _controllerList) {
      if (con is! AppControllerMVC) {
        continue;
      }
      try {
        if (!con.onAsyncError(details)) {
          handled = false;
        }
      } catch (ex) {
        handled = false;
      }
    }
    StateMVC._rebuildAllowed = true;
    return handled;
  }

  /// Calls the Flutter App's object (AppMVC) own initApp() function.
  /// It's where non-synchronous operations are performed when the app is starting up.
  @override
  void initState() {
    super.initState();
    widget.initApp();
  }

  //todo: Look at the State object's error routine.
  // /// Call the StatefulWidget's error routine;
  // @override
  // void onError(FlutterErrorDetails details) => widget.onError(details);

  /// Dispose the 'StateView(s)' that may be running.
  @protected
  @mustCallSuper
  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}

/// Builds a [InheritedWidget].
///
/// It's instantiated in a standalone widget
/// so its setState() call will **only** rebuild
/// [InheritedWidget] and consequently any of its dependents,
/// instead of rebuilding the app's entire widget tree.
class _InheritedMVC extends StatefulWidget {
  const _InheritedMVC({Key? key, required this.state, required this.child})
      : super(key: key);
  final AppStateMVC state;
  final Widget child;

  /// Allows for the static setState() function defined in this StatefulWidget
  static final _inheritedState = _InheritedMVCState();

  @override
  //ignore: no_logic_in_create_state
  State createState() => _inheritedState;

  /// Calls the build() function in this Widget's State object.
  static void setState(VoidCallback fn) => _inheritedState.setState(fn);
}

class _InheritedMVCState extends State<_InheritedMVC> {
  /// Introduce an Inherited widget and simply passing through a 'child' widget.
  /// When the Inherited Widget is rebuilt only this build() function is called.
  /// i.e. The rest of the widget tree, widget.child, is left alone.
  @override
  Widget build(BuildContext context) => _InheritedWidget(
        state: widget.state,
        object: widget.state.dataObject,
        child: widget.child,
      );

  /// Override again merely to prevent the warning message:
  /// The member 'setState' can only be used within instance members of
  /// subclasses of 'package:flutter/src/widgets/framework.dart'.
  @override
  void setState(VoidCallback fn) => super.setState(fn);
}

class _InheritedWidget extends InheritedWidget {
  ///
  const _InheritedWidget({
    Key? key,
    required this.state,
    required this.object,
    required Widget child,
  }) : super(key: key, child: child);
  final AppStateMVC state;
  final Object? object;

  /// Included temporarily for demonstration purposes.
  /// Place a breakpoint to see this function execute
  @override
  InheritedElement createElement() => InheritedElement(this);

  ///
  @override
  bool updateShouldNotify(_InheritedWidget oldWidget) {
    bool notify = false;
    // Flag all dependencies to rebuild
    if (state._buildInherited) {
      // Turn it off right away
      state._buildInherited = false;
      notify = true;
      // If the SetState class is being used and there's an object passed down the widget tree.
    } else if (state._setStates && object != null && !state._inBuilder) {
      notify = oldWidget.object != object;
    }
    return notify;
  }
}

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
///  More information:
///  https://medium.com/flutter-community/shrine-in-mvc-7984e08d8e6b#488c
@protected
class SetState extends StatelessWidget {
  const SetState({Key? key, required this.builder}) : super(key: key);
  final BuilderWidget builder;

  /// Calls the required Function object:
  /// Function(BuildContext context, T? object)
  /// and passes along the InheritWidget's custom 'object'
  ///
  @override
  Widget build(BuildContext context) {
    /// Go up the widget tree and link to the App's inherited widget, _InheritedWidget
    final inheritWidget =
        context.dependOnInheritedWidgetOfExactType<_InheritedWidget>();
    final AppStateMVC? state = inheritWidget?.state;
    if (state != null) {
      state
        .._setStates = true
        .._inBuilder = true;
      StateMVC._rebuildAllowed = false;
    }
    final Object? object = inheritWidget?.object;
    final Widget widget = builder(context, object);
    if (state != null) {
      StateMVC._rebuildAllowed = true;
      state._inBuilder = false;
    }
    return widget;
  }
}

/// The 'type of function' required by the class, SetState.
typedef BuilderWidget<T extends Object> = Widget Function(
    BuildContext context, T? object);

/// A Mixin to make a Controller for the 'app level' to influence the whole app.
mixin AppControllerMVC on ControllerMVC {
  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  @Deprecated('No need to replace the initState() function. Use initState()')
  void initApp() {}

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  bool onAsyncError(FlutterErrorDetails details) => false;

  /// Override if you like to customize your error handling.
  void onError(FlutterErrorDetails details) => state?.onError(details);
}

// Uuid
// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this Uuid function is governed by the M.I.T. license that can be found
// in the LICENSE file under Uuid.
//
/// A UUID generator, useful for generating unique IDs.
/// Shamelessly extracted from the author of Scoped Model plugin,
/// Who maybe took from the Flutter source code. I'm not telling!
///
/// This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// ### Example
///
///     final String id = Uuid().generateV4();
class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
