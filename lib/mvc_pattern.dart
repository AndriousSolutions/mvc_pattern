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
        InheritedWidget,
        Key,
        Locale,
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
        protected,
        required;

/// This class is to be concerned with the data
/// It is accessed by the Controller but can call setState() as well.
class ModelMVC extends StateSetter {
  //
  ModelMVC([StateMVC state]) : super() {
    pushState(state);
  }
}

/// Your 'working' class most concerned with the app's functionality.
class ControllerMVC extends StateSetter with StateListener {
  //
  ControllerMVC([StateMVC state]) : super() {
    addState(state);
  }

  /// Associate this Controller to the specified State object
  /// to use that State object's functions and features.
  String addState(StateMVC state) {
    if (state == null) {
      return '';
    }
    return state.add(this);
  }

  /// The current StateMVC object.
  StateMVC get stateMVC => _stateMVC;

  /// The current State object.
  State get state => _stateMVC;

  /// Return a List of Controllers specified by key id.
  List<ControllerMVC> listControllers(List<String> keys) =>
      _stateMVC.listControllers(keys);

  /// Retrieve the 'before' listener by its unique key.
  StateListener beforeListener(String key) => _stateMVC?.beforeListener(key);

  /// Retrieve the 'after' listener by its unique key.
  StateListener afterListener(String key) => _stateMVC?.afterListener(key);
}

/// Allows you to call 'setState' for the current the State object.
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
  StateMVC _stateMVC;
  final Set<StateMVC> _stateMVCSet = {};

  void pushState(StateMVC state) {
    if (state == null) {
      return;
    }
    _stateMVC = state;
    _stateMVCSet.add(state);
  }

  bool removeState(StateMVC state) {
    if (state == null) {
      return false;
    }
    if (state == _stateMVC) {
      return popState();
    }
    return _stateMVCSet.remove(state);
  }

  bool popState() {
    // Don't continue if null.
    if (_stateMVC == null) {
      return false;
    }
    // Remove the 'current' state
    final removed = _stateMVCSet.remove(_stateMVC);
    // Reassign the last state object.
    if (_stateMVCSet.isEmpty) {
      _stateMVC = null;
    } else {
      _stateMVC = _stateMVCSet.last;
    }
    return removed;
  }

  /// Return a 'copy' of the Set of State objects.
  Set<StateMVC> get states => Set.from(_stateMVCSet.whereType<StateMVC>());
}

/// Responsible for the event handling in all the Controllers, Listeners and Views.
mixin StateListener {
  // Assigned an unique key.
  String get keyId => _keyId;
  final String _keyId = Uuid().generateV4();

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  /// The framework will call this method exactly once.
  /// Only when the [State] object is first created.
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  /// The framework calls this method when this [State] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
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

  /// Called when a dependency of this [State] object changes.
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

/// Main State Object seen as the 'View of the State.'
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
    if (WidgetsBinding.instance == null ||
        WidgetsBinding.instance is WidgetsFlutterBinding) {
      /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
      FlutterError.onError = onError;
    }

    /// IMPORTANT! Assign itself to stateView before adding any Controller. -gp
    /// Any subsequent calls to add() will be assigned, stateMVC.
    _stateMVC = this;
    add(_controller);
  }
  ControllerMVC _controller;

  /// The View!
  @override
  Widget build(BuildContext context);

  /// Save the current Error Handler.
  final FlutterExceptionHandler currentErrorFunc;

  /// You need to be able access the widget.
  @override
  T get widget => super.widget;

  /// Provide the 'main' controller to this 'State View.'
  /// If _controller == null, get the 'first assigned' controller.
  ControllerMVC get controller => _controller ??= firstCon;

  /// Retrieve a Controller by its a unique String identifier.
  ControllerMVC controllerById(String keyId) => super._con(keyId);

  /// Add a specific Controller to this View.
  /// Returns the Controller's unique String identifier.
  @override
  String add(ControllerMVC c) {
    if (c == null) {
      return '';
    }

    /// It may have been a listener. Can't be both.
    removeListener(c);
    return super.add(c);
  }

  @override
  void addList(List<ControllerMVC> list) {
    if (list == null) {
      return;
    }

    /// It may have been a listener. Can't be both.
//    list.forEach((ControllerMVC con) => removeListener(con));
    return super.addList(list);
  }

  /// The Unique key identifier for this State object.
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
  U controllerByType<U extends ControllerMVC>() {
    // Look in this State objects list of Controllers.  Maybe not?
    U con = _cons[_type<U>()];
    return con ??= AppMVC._controllers[_type<U>()];
  }

  Type _type<U>() => U;

  /// May be set false to prevent unnecessary 'rebuilds'.
  bool _rebuildAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _rebuildRequested = false;

  /// A flag indicating initAsync was called
  bool futureBuilt = false;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  @mustCallSuper
  Future<bool> initAsync() async {
    /// It's been done. Don't run again.
    if (futureBuilt) {
      return futureBuilt;
    }

    /// This will call any and all Controllers that need asynchronous operations
    /// completed before continuing.
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final listener in _beforeList) {
      await listener.initAsync();
    }
    bool after = true;
    // Built if nothing to run.
    if (_controllerList.isEmpty) {
      futureBuilt = true;
    }
    for (final con in _controllerList) {
      futureBuilt = await con.initAsync();
      if (!futureBuilt) {
        // It's to continue but in error.
        futureBuilt = true;
        after = false;
        break;
      }
    }
    if (after) {
      for (final listener in _afterList) {
        await listener.initAsync();
      }
    }
    _rebuildAllowed = true;
    // Set the flag
    return futureBuilt;
  }

  /// The framework will call this method exactly once.
  /// Only when the [State] object is first created.
  @protected
  @override
  @mustCallSuper
  void initState() {
    assert(mounted, '${this.toString()} is not instantiated properly.');

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
    WidgetsBinding.instance.addObserver(this);

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

  /// The framework calls this method when this [State] object will never
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
      con.popState();

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
    WidgetsBinding.instance.removeObserver(this);

    // Remove any 'Controller' reference
    _controller = null;

    // Clear the list of Controllers.
    _cons.clear();

    // Return the original error routine.
    FlutterError.onError = currentErrorFunc;

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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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
    if (_rebuildRequested) {
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

      /// Call the State object's setState() function.
      super.setState(fn);
      _rebuildAllowed = true;
    } else {
      /// Can't rebuild at this moment but at least make the request.
      _rebuildRequested = true;
    }
  }

  /// Allows the user to call setState() within the Controller.
  void refresh() {
    if (mounted) {
      /// Refresh the interface by 'rebuilding' the Widget Tree
      setState(() {});
    } else {
      /// Refresh the interface by 'rebuilding' the Widget Tree
      setState(() {});
    }
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  // details.exception, details.stack
  @protected
  void onError(FlutterErrorDetails details) => currentErrorFunc(details);

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  @override
  bool onAsyncError(FlutterErrorDetails details) {
    /// This will call any and all Controllers
    /// that may have ran asynchronous operations.
    bool handled = true;

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    for (final con in _controllerList) {
      try {
        if (!con.onAsyncError(details)) {
          handled = false;
        }
      } catch (ex) {
        handled = false;
      }
    }
    _rebuildAllowed = false;
    return handled;
  }
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

  List<StateListener> _getList(List<String> keys, Set<StateListener> set) {
    final List<StateListener> list = [];
    if (keys == null || keys.isEmpty) {
      return list;
    }
    set.map((StateListener evt) {
      for (final key in keys) {
        if (evt._keyId == key) {
          list.add(evt);
          keys.remove(key);
          break;
        }
      }
    });
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
  StateListener beforeListener(String key) =>
      _getStateEvents(key, _listenersBefore);

  /// Returns the specified 'after' listener.
  StateListener afterListener(String key) =>
      _getStateEvents(key, _listenersAfter);

  StateListener _getStateEvents(String key, Set<StateListener> set) {
    StateListener se;
    if (key == null || key.isEmpty) {
      return se;
    }
    set.map((StateListener evt) {
      if (evt._keyId == key) {
        se = evt;
        return;
      }
    });
    return se;
  }

  void _disposeStateEventList() {
    _listenersBefore.clear();
    _listenersAfter.clear();
  }
}

mixin _ControllerListing {
  StateMVC _stateMVC;

  // Keep it private to allow subclasses to use 'con.'
  ControllerMVC _con(String keyId) {
    if (keyId == null || keyId.isEmpty) {
      return null;
    }
    return _map[keyId];
  }

  void addList(List<ControllerMVC> list) => list.forEach(add);

  List<ControllerMVC> listControllers(List<String> keys) =>
      _controllers(keys).values.toList();

  /// Never supply a public list of Controllers. User must know the key identifier(s).
  List<ControllerMVC> get _controllerList => _asList; //_controllers.asList;

  Map<String, ControllerMVC> _controllers(List<String> keys) {
    final Map<String, ControllerMVC> controllers = {};

    for (final key in keys) {
      controllers[key] = map[key];
    }
    return controllers;
  }

  final Map<String, ControllerMVC> _map = {};

  Map<String, ControllerMVC> get map => _map;

  List<ControllerMVC> get _asList => _map.values.toList();

  String add(ControllerMVC con) {
    if (con == null) {
      return '';
    }

    /// This connects the Controller to this View!
    con.pushState(_stateMVC);

    final String keyId = (contains(con)) ? con._keyId : addConId(con);

    AppMVC._addStateMVC(this);

    if (!_cons.containsValue(con)) {
      _cons.addAll({con.runtimeType: con});
    }

    /// It's already there?! Return its key.
    return keyId;
  }

  bool remove(String keyId) {
    final con = _map[keyId];
    final there = con != null;
    if (there) {
      con.removeState(_stateMVC);
      _map.remove(keyId);
    }
    return there;
  }

  ControllerMVC get firstCon => _asList.first;

  bool contains(ControllerMVC con) => _map.containsValue(con);

  void _disposeControllerListing() => _map.clear();

  String addConId(ControllerMVC con) {
    final keyId = con.keyId; //_addKeyId(con);
    _map[keyId] = con;
    return keyId;
  }

  final Map<Type, ControllerMVC> _cons = {};
}

/// The StatMVC object at the 'app level.' Used to effect the whole app.
abstract class ViewMVC<T extends StatefulWidget> extends StateMVC<T> {
  ViewMVC({
    ControllerMVC controller,
    this.controllers,
    this.object,
  }) : super(controller) {
    addList(controllers?.toList());
  }
  final List<ControllerMVC> controllers;
  Object object;

  /// Implement this function to compose the App's View.
  /// Override to impose your own WidgetsApp (like CupertinoApp or MaterialApp)
  Widget buildApp(BuildContext context);

  @override
  Widget build(BuildContext context) =>
      _InheritedMVC(state: this, object: object, child: buildApp(context));

  @override
  void setState(VoidCallback fn) {
    if (!inBuilder) {
      super.setState(fn);
    }
  }

  @override
  void refresh() {
    if (!inBuilder) {
      super.refresh();
    }
  }

  /// Catch and explicitly handle the error.
  void catchError(Exception ex) {
    if (ex == null) {
      return;
    }
    FlutterError.onError(FlutterErrorDetails(exception: ex));
  }

  bool inBuilder = false;
  bool setStates = false;
}

class _InheritedMVC<T extends Object> extends InheritedWidget {
  const _InheritedMVC({Key key, this.state, this.object, Widget child})
      : super(key: key, child: child);
  final ViewMVC state;
  final T object;
  @override
  bool updateShouldNotify(_InheritedMVC oldWidget) =>
      state.setStates && !state.inBuilder;
}

///  Used like the function, setState(), to 'spontaneously' call
///  build() functions here and there in your app. Much like the Scoped
///  Model's ScopedModelDescendant() class.
@protected
class SetState extends StatelessWidget {
  const SetState({Key key, @required this.builder})
      : assert(builder != null, 'Must provide a builder to SetState()'),
        super(key: key);
  final BuilderWidget builder;

  @override
  Widget build(BuildContext context) {
    /// Go up the widget tree and obtain the closes 'View'
    final _InheritedMVC inheritWidget =
        context.dependOnInheritedWidgetOfExactType<_InheritedMVC>();
    final ViewMVC state = inheritWidget?.state;
    if (state != null) {
      state
        ..setStates = true
        ..inBuilder = true
        .._rebuildAllowed = false;
    }
    final Object object = inheritWidget?.object;
    final Widget widget = builder(context, object);
    if (state != null) {
      state
        .._rebuildAllowed = true
        ..inBuilder = false;
    }
    return widget;
  }
}

typedef BuilderWidget<T extends Object> = Widget Function(
    BuildContext context, T object);

/// A Controller for the 'app level' to influence the whole app.
class AppConMVC extends ControllerMVC {
  AppConMVC([StateMVC state]) : super(state);

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  void initApp() {}

  /// Override if you like to customize your error handling.
  void onError(FlutterErrorDetails details) => stateMVC?.onError(details);
}

/// Main or first class to pass to the 'main.dart' file's runApp() function.
/// AppStatefulWidget is its subclass
abstract class AppMVC extends StatefulWidget {
  /// Simple constructor. Calls the initApp() function.
  AppMVC({this.con, Key key})
      : _appState = _AppState(con),
        super(key: key);
  final AppConMVC con;

  final _AppState _appState;

  /// Get the controller if any
  ControllerMVC get controller => con;

  /// Create the View!
  Widget build(BuildContext context);

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  @mustCallSuper
  void initApp() => con?.initApp();

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  Future<bool> initAsync() => _appState.initAsync();

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

  /// Override if you like to customize your error handling.
  void onError(FlutterErrorDetails details) {
    if (con != null) {
      con.onError(details);
    } else {
      // Call the State object's Exception handler
      _appState.currentErrorFunc(details);
    }
  }

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Returns a StateView object using a unique String identifier.
  // There's a better way. Just too tired now.
  static StateMVC getState(String keyId) {
    StateMVC sv;
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
  static void _addStateMVC(StateMVC state) {
    final Map<String, StateMVC> map = {};
    map[state._keyId] = state;
    _states.add(map);
    for (final con in state._controllerList) {
      _controllers.addAll({con.runtimeType: con});
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State createState() => _appState;
}

class _AppState extends StateMVC<AppMVC> {
  //
  _AppState(ControllerMVC con) : super(con);

  @override
  void initState() {
    super.initState();
    widget.initApp();
  }

  /// The underlying App state should not be rebuilt.
  @override
  // ignore: avoid_returning_null_for_void
  void setState(VoidCallback fn) => null;

  @override
  Widget build(BuildContext context) => widget.build(context);

  /// Call the StatefulWidget's error routine;
  @override
  void onError(FlutterErrorDetails details) => widget.onError(details);

  /// Dispose the 'StateView(s)' that may be running.
  @protected
  @mustCallSuper
  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
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
