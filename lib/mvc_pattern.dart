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

import 'dart:math' show Random;
import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show FlutterExceptionHandler;
import 'package:flutter/material.dart'
    show
        AppLifecycleState,
        BuildContext,
        FlutterError,
        FlutterErrorDetails,
        Key,
        Locale,
        State,
        StatefulWidget,
        VoidCallback,
        Widget,
        WidgetsBinding,
        WidgetsBindingObserver,
        mustCallSuper,
        protected;

import 'package:flutter_test/flutter_test.dart'
    show Future, TestWidgetsFlutterBinding;

/// Controller Class
/// Your 'working' class most concerned with the app's functionality.
abstract class ControllerMVC extends _StateObserver {
  ControllerMVC([StateMVC state]) : super() {
    addState(state);
  }

  String addState(StateMVC state) {
    if (state == null) return '';
    return state.add(this);
  }
}

class _StateObserver with _StateSetter, StateListener {
//  /// Records the current error handler and supplies its own.
//  _StateObserver() : _oldOnError = _recOnError() {
//    /// If a tester is running. Don't switch out its error handler.
//    if (WidgetsBinding.instance is! TestWidgetsFlutterBinding) {
//      /// This allows you to place a breakpoint at 'onError(details)' to determine error location.
//      FlutterError.onError = (FlutterErrorDetails details) {
//        var thisOnError = onError;
//
//        /// Always favour a custom error handler.
//        if (thisOnError == StateMVC._defaultError &&
//            _oldOnError != StateMVC._defaultError) {
//          _oldOnError(details);
//        } else {
//          onError(details);
//        }
//      };
//    }
//  }
//
//  /// Save the current Error Handler.
//  final Function(FlutterErrorDetails details) _oldOnError;

  StateMVC get stateMVC => _stateMVC;

  /// Start using the getter, stateMVC
  @deprecated
  StateMVC get stateView => _stateMVC;

  /// Overridden by mixin, StateSetter.
  StateMVC _stateMVC;

  List<ControllerMVC> listControllers(List<String> keys) =>
      _stateMVC.listControllers(keys);

  /// Provide the setState() function to external actors
  void setState(fn) => _stateMVC?.setState(fn);

  /// Allows external classes to 'refresh' or 'rebuild' the widget tree.
  void refresh() => _stateMVC?.refresh();

//  /// Add a listener fired 'before' the main controller runs.
//  bool addBeforeListener(StateListener listener) =>
//      _stateMVC?.addBeforeListener(listener);
//
//  /// Add a listener fired 'after' the main controller runs.
//  bool addAfterListener(StateListener listener) =>
//      _stateMVC?.addAfterListener(listener);
//
//  /// Add a listener fired 'after' the main controller runs.
//  bool addListener(StateListener listener) =>
//      _stateMVC?.addAfterListener(listener);
//
//  /// Removes a specified listener.
//  bool removeListener(StateListener listener) =>
//      _stateMVC?.removeListener(listener);

  /// Retrieve the 'before' listener by its unique key.
  StateListener beforeListener(String key) => _stateMVC?.beforeListener(key);

  /// Retrieve the 'after' listener by its unique key.
  StateListener afterListener(String key) => _stateMVC?.afterListener(key);

  /// Dispose the State Object and Controller references.
  @mustCallSuper
  void dispose() {
    /// The view association is severed.
    _disposeState();
    super.dispose();
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  /// The default routine is to dump the error to the console.
  // details.exception, details.stack
  @deprecated
  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);
}

mixin _StateSetter {
  StateMVC _stateMVC;
  final Set<StateMVC> _stateMVCSet = Set();

  void _addState(StateMVC state) {
    if (state == null) return;
    _stateMVC = state;
    _stateMVCSet.add(state);
  }

  bool _removeState(StateMVC state) {
    if (state == null) return false;
    if (state == _stateMVC) return _disposeState();
    return _stateMVCSet.remove(state);
  }

  bool _disposeState() {
    // Don't continue if null.
    if (_stateMVC == null) return false;
    // Remove the 'current' state
    bool removed = _stateMVCSet.remove(_stateMVC);
    // Reassign the last state object.
    if (_stateMVCSet.isEmpty) {
      _stateMVC = null;
    } else {
      _stateMVC = _stateMVCSet.last;
    }
    return removed;
  }
}

/// Responsible for the event handling in all the Controllers, Listeners and Views.
mixin StateListener {
  // Assigned an unique key.
  String get keyId => _keyId;
  String _keyId = Uuid().generateV4();

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
  /// build again. The [State] object's lifecycle is terminated.
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).
  }

  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
  }

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

  /// Called when the system tells the app that the user's locale has changed.
  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
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
}

/// Main State Object seen as the 'StateView.'
abstract class StateMVC<T extends StatefulWidget> extends State<StatefulWidget>
    with WidgetsBindingObserver, _ControllerListing, _StateListeners
    implements StateListener {
  /// The View!
  Widget build(BuildContext context);

  /// You need to be able access the widget.
  T get widget => super.widget;

  /// Record the 'default' error handler for Flutter.
  static final FlutterExceptionHandler _defaultError = FlutterError.onError;

  /// With an optional Controller parameter, this constructor imposes its own Errror Handler.
  StateMVC([this._controller]) : _oldOnError = _recOnError() {
    /// If a tester is running. Don't switch out its error handler.
    if (WidgetsBinding.instance is! TestWidgetsFlutterBinding) {
      /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
      FlutterError.onError = (FlutterErrorDetails details) {
        Function(FlutterErrorDetails details) thisOnError = onError;

        /// Always favour a custom error handler.
        if (thisOnError == _defaultError && _oldOnError != _defaultError) {
          _oldOnError(details);
        } else {
          onError(details);
        }
      };
    }

    /// IMPORTANT! Assign itself to stateView before adding any Controller. -gp
    /// Any subsequent calls to add() will be assigned, stateMVC.
    _stateMVC = this;
    add(_controller);
  }
  ControllerMVC _controller;

  /// Save the original Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;

  /// Provide the 'main' controller to this 'State View.'
  /// If _controller == null, get the 'first assigned' controller.
  ControllerMVC get controller {
    if (_controller == null) _controller = firstCon;
    return _controller;
  }

  /// Retrieve a Controller by its a unique String identifier.
  ControllerMVC controllerById(String keyId) => super._con(keyId);

  /// Add a specific Controller to this View.
  /// Returns the Controller's unique String identifier.
  String add(ControllerMVC c) {
    if (c == null) return '';

    /// It may have been a listener. Can't be both.
    removeListener(c);
    return super.add(c);
  }

  void addList(List<ControllerMVC> list) {
    if (list == null) return;

    /// It may have been a listener. Can't be both.
    list.forEach((ControllerMVC con) => removeListener(con));
    return super.addList(list);
  }

  /// The Unique key identifier for this State object.
  String get keyId => _keyId;

  /// Contains the unique String identifier.
  String _keyId = Uuid().generateV4();

  /// May be set false to prevent unnecessary 'rebuilds'.
  bool _rebuildAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _rebuildRequested = false;

  /// The framework will call this method exactly once.
  /// Only when the [State] object is first created.
  @protected
  @override
  @mustCallSuper
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppMVC._addStateMVC(this);

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
//    _controllerList.forEach((ControllerMVC con) => con._widget = widget);
    _beforeList.forEach((StateListener listener) => listener.initState());
    _controllerList.forEach((ControllerMVC con) => con.initState());
    _afterList.forEach((StateListener listener) => listener.initState());
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
    _beforeList.forEach((StateListener listener) => listener.deactivate());
    _controllerList.forEach((ControllerMVC con) => con.deactivate());
    _afterList.forEach((StateListener listener) => listener.deactivate());
    super.deactivate();
    _rebuildAllowed = true;
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

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener listener) => listener.dispose());
    _controllerList.forEach((ControllerMVC con) => con.dispose());
    _disposeControllerListing();
    _afterList.forEach((StateListener listener) => listener.dispose());
    _disposeStateEventList();

    /// Should not be 'rebuilding' anyway. This Widget is going away.
    _rebuildAllowed = true;
    _rebuildRequested = false;
    WidgetsBinding.instance.removeObserver(this);

    /// Remove any 'Controller' reference
    _controller = null;

    /// Return the original error routine.
    FlutterError.onError = _oldOnError;
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

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList.forEach(
        (StateListener listener) => listener.didUpdateWidget(oldWidget));
    _controllerList
        .forEach((ControllerMVC con) => con.didUpdateWidget(oldWidget));
    _afterList.forEach(
        (StateListener listener) => listener.didUpdateWidget(oldWidget));
    super.didUpdateWidget(oldWidget);
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @protected
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList.forEach(
        (StateListener listener) => listener.didChangeAppLifecycleState(state));
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAppLifecycleState(state));
    _afterList.forEach(
        (StateListener listener) => listener.didChangeAppLifecycleState(state));
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @protected
  @override
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
    _beforeList
        .forEach((StateListener listener) => listener.didChangeMetrics());
    _controllerList.forEach((ControllerMVC con) => con.didChangeMetrics());
    _afterList.forEach((StateListener listener) => listener.didChangeMetrics());
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
    _beforeList.forEach(
        (StateListener listener) => listener.didChangeTextScaleFactor());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeTextScaleFactor());
    _afterList.forEach(
        (StateListener listener) => listener.didChangeTextScaleFactor());
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
  //@override
  void didChangeLocale(Locale locale) {
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList
        .forEach((StateListener listener) => listener.didChangeLocale(locale));
    _controllerList.forEach((ControllerMVC con) => con.didChangeLocale(locale));
    _afterList
        .forEach((StateListener listener) => listener.didChangeLocale(locale));
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
  void didHaveMemoryPressure() {
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList
        .forEach((StateListener listener) => listener.didHaveMemoryPressure());
    _controllerList.forEach((ControllerMVC con) => con.didHaveMemoryPressure());
    _afterList
        .forEach((StateListener listener) => listener.didHaveMemoryPressure());
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
  void didChangeAccessibilityFeatures() {
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList.forEach(
        (StateListener listener) => listener.didChangeAccessibilityFeatures());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAccessibilityFeatures());
    _afterList.forEach(
        (StateListener listener) => listener.didChangeAccessibilityFeatures());
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
  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList
        .forEach((StateListener listener) => listener.didChangeDependencies());
    _controllerList.forEach((ControllerMVC con) => con.didChangeDependencies());
    _afterList
        .forEach((StateListener listener) => listener.didChangeDependencies());
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

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @protected
  @mustCallSuper
  @override
  void reassemble() {
    /// No 'setState()' functions are allowed to fully function at this point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener listener) => listener.reassemble());
    _controllerList.forEach((ControllerMVC con) => con.reassemble());
    _afterList.forEach((StateListener listener) => listener.reassemble());
    super.reassemble();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Allows 'external' routines can call this function.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  void setState(VoidCallback fn) {
    if (_rebuildAllowed) {
      /// Call the State object's setState() function.
      super.setState(fn);
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
    }
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  /// The default routine is to dump the error to the console.
  // details.exception, details.stack
  @protected
  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);
}

/// Records 'the current' error handler.
Function(FlutterErrorDetails details) _recOnError() {
  var func;

  /// If the 'current' Error Handler is not the 'default' routine, you better save it.
  if (FlutterError.onError != StateMVC._defaultError) {
    func = FlutterError.onError;
  } else {
    func = StateMVC._defaultError;
  }
  return func;
}

/// Add, List, and Remove Listeners.
mixin _StateListeners {
  List<StateListener> get _beforeList => _listenersBefore.toList();
  List<StateListener> beforeList(List<String> keys) {
    return _getList(keys, _listenersBefore);
  }

  final Set<StateListener> _listenersBefore = Set();

  List<StateListener> get _afterList => _listenersAfter.toList();
  List<StateListener> afterList(List<String> keys) {
    return _getList(keys, _listenersAfter);
  }

  List<StateListener> _getList(List<String> keys, Set<StateListener> set) {
    List<StateListener> list = List();
    if (keys == null || keys.isEmpty) return list;
    set.map((StateListener evt) {
      for (String key in keys) {
        if (evt._keyId == key) {
          list.add(evt);
          keys.remove(key);
          break;
        }
      }
    });
    return list;
  }

  final Set<StateListener> _listenersAfter = Set();

  /// Add a listener fired 'before' the main controller runs.
  bool addBeforeListener(StateListener listener) =>
      _listenersBefore.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addAfterListener(StateListener listener) =>
      _listenersAfter.add(listener);

  /// Add a listener fired 'after' the main controller runs.
  bool addListener(StateListener listener) => addAfterListener(listener);

  bool removeListener(StateListener listener) {
    bool removed = _listenersBefore.remove(listener);
    if (_listenersAfter.remove(listener)) removed = true;
    return removed;
  }

  bool beforeContains(StateListener listener) =>
      _listenersBefore.contains(listener);

  bool afterContains(StateListener listener) =>
      _listenersAfter.contains(listener);

  StateListener beforeListener(String key) =>
      _getStateEvents(key, _listenersBefore);

  StateListener afterListener(String key) =>
      _getStateEvents(key, _listenersAfter);

  StateListener _getStateEvents(String key, Set<StateListener> set) {
    StateListener se;
    if (key == null || key.isEmpty) return se;
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

class _ControllerListing {
  StateMVC _stateMVC;

  // Keep it private to allow subclasses to use 'con.'
  ControllerMVC _con(String keyId) {
    if (keyId == null || keyId.isEmpty) return null;
    return _map[keyId];
  }

  void addList(List<ControllerMVC> list) =>
      list.forEach((ControllerMVC con) => add(con));

  List<ControllerMVC> listControllers(List<String> keys) =>
      controllers(keys).values.toList();

  /// Never supply a public list of Controllers. User must know the key identifier(s).
  List<ControllerMVC> get _controllerList => _asList; //_controllers.asList;

  Map<String, ControllerMVC> controllers(List<String> keys) {
    Map<String, ControllerMVC> controllers = {};
    keys.forEach(
        (String key) => controllers[key] = map[key]); //_controllers.map[key]);
    return controllers;
  }

  final Map<String, ControllerMVC> _map = Map();

  Map<String, ControllerMVC> get map => _map;

  List<ControllerMVC> get _asList => _map.values.toList();

  String add(ControllerMVC con) {
    if (con == null) return '';

    /// This connects the Controller to this View!
    con._addState(_stateMVC);

    /// It's already there?! Return its key.
    return (contains(con)) ? con._keyId : addConId(con);
  }

  bool remove(String keyId) {
    var con = _map[keyId];
    var there = con != null;
    if (there) {
      con._removeState(_stateMVC);
      _map.remove(keyId);
    }
    return there;
  }

  ControllerMVC get firstCon => _asList.first;

  bool contains(ControllerMVC con) => _map.containsValue(con);

  void _disposeControllerListing() => _map.clear();

  String addConId(ControllerMVC con) {
    String keyId = _addKeyId(con);
    _map[keyId] = con;
    return keyId;
  }
}

String _addKeyId(_StateObserver sv) {
  String keyId = sv._keyId;

  /// May already have been assigned a key.
  if (keyId.isEmpty) {
    keyId = Uuid().generateV4();
    sv._keyId = keyId;
  }
  return keyId;
}

/// View Class
/// Extend and implement its build() function to compose its interface.
abstract class ViewMVC extends _StateObserver with _ControllerListing {
  /// Implement this build() function to compose the View's interface.
  Widget build(BuildContext context);

  /// Must take in one Controller when this Class instantiates.
  ViewMVC(this.controller) {
    _addKeyId(this);

    // Add this Controller to the Controller Listing!
    add(controller);
  }
  final ControllerMVC controller;

  /// Retrieve a Controller from this View.
  /// Retrieved by using a unique String identifier.
  ControllerMVC con(String keyId) {
    assert(_stateMVC != null, "Pass this ViewMVC to a StateViewMVC!");
    return super._con(keyId);
  }

  /// Add a Controller to this View.
  @override
  String add(ControllerMVC c) {
    assert(_stateMVC != null, "Pass this ViewMVC to a StateViewMVC!");
    return super.add(c);
  }

  /// Called to 'clean up' the List of Controllers and such
  /// associated with this View.
  @override
  void dispose() {
    _disposeControllerListing();
    super.dispose();
  }
}

/// The State Object with an Error Handler in its build() function.
abstract class StateViewMVC<T extends StatefulWidget> extends StateMVC<T> {
  /// Takes in a View and passes the View's Controller to the parent class.
  StateViewMVC(this.view) : super(view.controller) {
    assert(view != null, "View can't be null! Pass a ViewMVC to StateViewMVC.");

    /// IMPORTANT! Add the View's controllers first before calling setter. -gp
    addList(view._controllerList);

    /// Clear any controllers associated.
    view._disposeControllerListing();

    /// IMPORTNANT! This setter connects the State Object!
    view._stateMVC = this;
    view._addState(this);
  }
  final ViewMVC view;

  /// Supply the every Widget returned by the build() function.
  Widget get buildWidget => _widget;
  Widget _widget;

  Function(FlutterErrorDetails details) _currentOnError;

  /// The build function wrapped in an Error Handler to prevent
  /// crashes from unruly Controllers and or Listeners.
  @override
  @protected
  Widget build(BuildContext context) {
    /// Save the current Error Handler if any.
    _currentOnError = FlutterError.onError;

    /// If a tester is running. Don't switch out its error handler.
    if (WidgetsBinding.instance is! TestWidgetsFlutterBinding) {
      FlutterError.onError = (FlutterErrorDetails details) {
        /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
        var thisOnError = onError;

        /// Always favour a custom error handler.
        if (thisOnError != StateMVC._defaultError) {
          onError(details);
        } else if (_currentOnError != StateMVC._defaultError) {
          /// Likely a Controller Error Handler.
          _currentOnError(details);
        } else if (_oldOnError != StateMVC._defaultError) {
          /// An even older routine is available? App level routine?
          _oldOnError(details);
        } else {
          /// You've not choice. Run the ol' 'red screen of death'
          onError(details);
        }
      };
    }

    /// Where the magic happens!
    _widget = view.build(context);

    /// Restore the current error handler.
    FlutterError.onError = _currentOnError;
    return _widget;
  }

  @protected
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    view.initState();
  }

  @protected
  @override
  @mustCallSuper
  void deactivate() {
    view.deactivate();
    super.deactivate();
  }

  /// Dispose any View and its Controllers
  @protected
  @override
  @mustCallSuper
  void dispose() {
    view.dispose();
    super.dispose();
  }

  @protected
  @override
  @mustCallSuper
  void didUpdateWidget(StatefulWidget oldWidget) {
    view.didUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @protected
  @override
  @mustCallSuper
  void didChangeAppLifecycleState(AppLifecycleState state) {
    view.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @protected
  @override
  @mustCallSuper
  void didChangeMetrics() {
    view.didChangeMetrics();
    super.didChangeMetrics();
  }

  @protected
  @override
  @mustCallSuper
  void didChangeTextScaleFactor() {
    view.didChangeTextScaleFactor();
    super.didChangeTextScaleFactor();
  }

  @protected
  @override
  @mustCallSuper
  void didChangeLocale(Locale locale) {
    view.didChangeLocale(locale);
    super.didChangeLocale(locale);
  }

  @protected
  @override
  @mustCallSuper
  void didHaveMemoryPressure() {
    view.didHaveMemoryPressure();
    super.didHaveMemoryPressure();
  }

  @protected
  @override
  @mustCallSuper
  void didChangeAccessibilityFeatures() {
    view.didChangeAccessibilityFeatures();
    super.didChangeAccessibilityFeatures();
  }

  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    view.didChangeDependencies();
    super.didChangeDependencies();
  }

  @protected
  @override
  @mustCallSuper
  void reassemble() {
    view.reassemble();
    super.reassemble();
  }
}

/// Main or first class to pass to the 'main.dart' file's runApp() function.
abstract class AppMVC extends StatefulWidget {
  /// Simple constructor. Calls the initApp() function.
  AppMVC({this.con, Key key}) : super(key: key);
  final ControllerMVC con;

  /// Get the controller if any
  ControllerMVC get controller => con;

  /// Create the View!
  Widget build(BuildContext context);

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  @mustCallSuper
  void initApp() {
    if (con is AppConMVC) (con as AppConMVC)?.initApp();
  }

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  Future<bool> init() async {
    bool init = true;
    if (con is AppConMVC) init = await (con as AppConMVC)?.init();
    return Future.value(init);
  }

  /// Called in State object.
  @mustCallSuper
  void dispose() {
    states.clear();
  }

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Determine if the 'MVCApp' is being used.
  static String _appStatus = '';

  static List<Map<String, StateMVC>> states = [];

  /// Returns a StateView object using a unique String identifier.
  // There's a better way. Just too tired now.
  static StateMVC getState(String keyId) {
    StateMVC sv;
    for (Map map in states) {
      if (map.containsKey(keyId)) {
        sv = map[keyId];
        break;
      }
    }
    return sv;
  }

  /// Returns a Map of StateView objects using unique String identifiers.
  static Map<String, StateMVC> getStates(List<String> keys) {
    Map map = Map<String, StateMVC>();
    keys.forEach((String key) {
      StateMVC sv = getState(key);
      if (sv != null) map[key] = sv;
    });
    return map;
  }

  /// Returns a List of StateView objects using unique String identifiers.
  static List<StateMVC> listStates(List<String> keys) {
    return getStates(keys).values.toList();
  }

  /// This is 'privatized' as it is an critical method and not for public access.
  static _addStateMVC(StateMVC state) {
    if (_appStatus == 'not running') return;
    if (_appStatus.isEmpty)
      _appStatus = _AppState.running ? 'running' : 'not running';
    var map = Map<String, StateMVC>();
    map[state._keyId] = state;
    states.add(map);
  }

  /// Create the 'controller' if not provided one.
  @override
  State createState() => _AppState(con ?? AppConMVC());
}

class _AppState extends StateMVC<AppMVC> {
  _AppState(this.con) : super(con);
  ControllerMVC con;

  void initState() {
    running = true;
    widget.initApp();
    super.initState();
  }

  /// If this class is running, indicate it so.
  static bool running = false;

  Widget build(BuildContext context) => widget.build(context);

  /// Dispose the 'StateView(s)' that may be running.
  @protected
  @mustCallSuper
  void dispose() {
    running = false;
    widget.dispose();
    super.dispose();
  }
}

class AppConMVC extends ControllerMVC {
  AppConMVC() : super();

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  void initApp() {}

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  Future<bool> init() async {
    return Future.value(true);
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
