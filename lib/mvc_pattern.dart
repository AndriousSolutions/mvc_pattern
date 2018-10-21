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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// You've got to extend this class to create a Controller
abstract class ControllerMVC extends _StateView {}

/// Extend to create a View.
abstract class ViewMVC extends _StateView {
  ViewMVC(this.controller) {
    _addKeyId(this);
    /// Assign a key id to this controller.
    _addKeyId(controller);
  }

  final ControllerMVC controller;

  build(BuildContext context);
}

class _StateView extends StateEvents {
  /// The View is a State object after all.
  State get state => _state;

  StateMVC get stateView => _stateMVC;

  /// VERY IMPORTANT! This setter connects the State Object!
  set stateView(StateMVC stateView) {
    assert(_stateMVC == null, "A View is already assigned!");
    _stateMVC = stateView;
    _state = stateView;
  }

  StateMVC _stateMVC;

  /// The controller is assigned an unique key.
  String get keyId => _keyId;
  String _keyId = '';

  List<ControllerMVC> listControllers(List<String> keys) =>
      _stateMVC.listControllers(keys);

  /// Provide the setState() function to the build() function.
  setState(fn) {
    _stateMVC?.setState(fn);
  }

  refresh() {
    _stateMVC?.refresh();
  }

  bool addBeforeListener(StateEvents obj) {
    /// Add a listener fired 'before' the main controller runs.
    return _stateMVC?.addBeforeListener(obj);
  }

  bool addAfterListener(StateEvents obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _stateMVC?.addAfterListener(obj);
  }

  bool addListener(StateEvents obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _stateMVC?.addAfterListener(obj);
  }

  bool removeListener(Object obj) {
    return _stateMVC?.removeListener(obj);
  }

  @mustCallSuper
  void dispose() {
    /// The view association is severed.
    _state = null;
    _stateMVC = null;
    super.dispose();
  }
}

/// If there's a new event, update StatedWidget &  _StatedController! -gp
class StateEvents {
  StateEvents() : _oldOnError = _recOnError() {
    /// This allows you to place a breakpoint at 'onError(details)' to determine error location.
    FlutterError.onError = (FlutterErrorDetails details) {
      var thisOnError = onError;

      /// Always favour a custom error handler.
      if (thisOnError == StateMVC._defaultError &&
          _oldOnError != StateMVC._defaultError) {
        _oldOnError(details);
      } else {
        onError(details);
      }
    };
  }

  /// Save the current Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;

  /// Allow for a reference to the State object.
  State _state;

  /// Allow access to the widget
  StatefulWidget get widget => _widget ?? _state?.widget;
  StatefulWidget _widget;

  /// BuildContext is always useful in the build() function.
  BuildContext get context => _state?.context;

  /// Ensure the State Object is 'mounted' and not being terminated.
  bool get mounted => _state?.mounted ?? false;

  void initState() {
    /// The framework will call this method exactly once.
    /// Only when the [State] object is first created.
    ///
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    /// Return to the original error routine.
    FlutterError.onError = _oldOnError;
  }

  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.
  }

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

  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].
  }

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

  void reassemble() {
    /// Called whenever the application is reassembled during debugging, for
    /// example during hot reload.
    ///
    /// This method should rerun any initialization logic that depends on global
    /// state, for example, image loading from asset bundles (since the asset
    /// bundle may have changed).
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  /// The default routine is to dump the error to the console.
  // details.exception, details.stack
  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);
}

class StateViewMVC extends StateMVC {
  StateViewMVC(this.view) : super(view.controller) {
    assert(view != null, "View can't be null! Pass a view to StateViewMVC.");

    /// This setter connects the State Object!
    view.stateView = this;
  }
  final ViewMVC view;

  Widget get buildWidget => _widget;
  Widget _widget;

  Function(FlutterErrorDetails details) _currentOnError;

  Widget build(BuildContext context) {
    /// Save the current Error Handler if any.
    _currentOnError = FlutterError.onError;
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

    /// Where the magic happens!
    _widget = view.build(context);

    /// Restore the current error handler.
    FlutterError.onError = _currentOnError;
    return _widget;
  }
}

abstract class StateMVC extends State<StatefulWidget>
    with WidgetsBindingObserver {
  /// The View!
  Widget build(BuildContext context);

  /// Record the 'default' error handler for Flutter.
  static final _defaultError = FlutterError.onError;

  StateMVC([ControllerMVC _con]) : _oldOnError = _recOnError() {
    /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
    FlutterError.onError = (FlutterErrorDetails details) {
      var thisOnError = onError;

      /// Always favour a custom error handler.
      if (thisOnError == _defaultError && _oldOnError != _defaultError) {
        _oldOnError(details);
      } else {
        onError(details);
      }
    };
    _eventHandler = _StateEventList(this);
    _conListing = _ControllerListing(this);
    add(_con);
  }

  /// Save the original Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;

  /// Contains a listing of all the Controllers assigned to this View.
  _ControllerListing _conListing;

  ControllerMVC con(String keyId) => _conListing.con(keyId);

  Map<String, ControllerMVC> controllers(List<String> keys) =>
      _conListing.getControllers(keys);

  List<ControllerMVC> get _controllerList => _conListing.controllerList;

  List<ControllerMVC> listControllers(List<String> keys) =>
      _conListing.listControllers(keys);

  set controller(ControllerMVC c) {
    add(c);
  }

  String add(ControllerMVC c) {
    /// It may have been a listener. Can't be both.
    removeListener(c);
    return _conListing.add(c);
  }

  void addList(List<ControllerMVC> list) => _conListing.addList(list);

  bool remove(String keyId) => _conListing.remove(keyId);

  List<StateEvents> get beforeList => _eventHandler.beforeList;
  List<StateEvents> get afterList => _eventHandler.afterList;
  _StateEventList _eventHandler;

  String get keyId => _keyId;
  String _keyId;

  /// May be set false to prevent unnecessary 'rebuilds'.
  bool _rebuildAllowed = true;

  /// May be set true to request a 'rebuild.'
  bool _rebuildRequested = false;

  @mustCallSuper
  @override
  void initState() {
    /// The framework will call this method exactly once.
    /// Only when the [State] object is first created.
    ///
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppMVC.addState(this);

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _controllerList.forEach((ControllerMVC con) => con._widget = widget);
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.initState());
    _controllerList.forEach((ControllerMVC con) => con.initState());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.initState());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  @mustCallSuper
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.deactivate());
    _controllerList.forEach((ControllerMVC con) => con.deactivate());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.deactivate());
    super.deactivate();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.dispose());
    _controllerList.forEach((ControllerMVC con) => con.dispose());
    _conListing.dispose();
    _eventHandler.afterList.forEach((StateEvents obj) => obj.dispose());
    _eventHandler.dispose();

    /// Should not be 'rebuilding' anyway. This Widget is going away.
    _rebuildAllowed = true;
    _rebuildRequested = false;
    WidgetsBinding.instance.removeObserver(this);

    /// Return the original error routine.
    FlutterError.onError = _oldOnError;
    super.dispose();
  }

  @mustCallSuper
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didUpdateWidget(oldWidget));
    _controllerList
        .forEach((ControllerMVC con) => con.didUpdateWidget(oldWidget));
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didUpdateWidget(oldWidget));
    super.didUpdateWidget(oldWidget);
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeAppLifecycleState(state));
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAppLifecycleState(state));
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeAppLifecycleState(state));
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeMetrics());
    _controllerList.forEach((ControllerMVC con) => con.didChangeMetrics());
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeMetrics());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeTextScaleFactor());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeTextScaleFactor());
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeTextScaleFactor());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeLocale(locale));
    _controllerList.forEach((ControllerMVC con) => con.didChangeLocale(locale));
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeLocale(locale));
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didHaveMemoryPressure());
    _controllerList.forEach((ControllerMVC con) => con.didHaveMemoryPressure());
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didHaveMemoryPressure());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeAccessibilityFeatures());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAccessibilityFeatures());
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeAccessibilityFeatures());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList
        .forEach((StateEvents obj) => obj.didChangeDependencies());
    _controllerList.forEach((ControllerMVC con) => con.didChangeDependencies());
    _eventHandler.afterList
        .forEach((StateEvents obj) => obj.didChangeDependencies());
    super.didChangeDependencies();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  @mustCallSuper
  @override
  void reassemble() {
    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.reassemble());
    _controllerList.forEach((ControllerMVC con) => con.reassemble());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.reassemble());
    super.reassemble();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  bool addBeforeListener(StateEvents obj) {
    /// Add a listener fired 'before' the main controller runs.
    return _eventHandler.addBefore(obj);
  }

  bool addAfterListener(StateEvents obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _eventHandler.addAfter(obj);
  }

  bool addListener(StateEvents obj) {
    /// Add a listener fired 'after' the main controller runs.
    return addAfterListener(obj);
  }

  bool removeListener(StateEvents obj) {
    return _eventHandler.remove(obj);
  }

  /// Allows 'external' routines can call this function.
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
    /// Refresh the interface by 'rebuilding' the Widget Tree
    setState(() {});
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  /// The default routine is to dump the error to the console.
  // details.exception, details.stack
  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);
}

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

class _StateEventList {
  _StateEventList(this.view);

  final StateMVC view;

  final Set<StateEvents> _listenersBefore = Set();
  List<StateEvents> get beforeList => _listenersBefore.toList();

  final Set<StateEvents> _listenersAfter = Set();
  List<StateEvents> get afterList => _listenersAfter.toList();

  bool addBefore(StateEvents obj) {
    return _listenersBefore.add(obj);
  }

  bool addAfter(StateEvents obj) {
    return _listenersAfter.add(obj);
  }

  bool remove(StateEvents obj) {
    bool removed;
    removed = _listenersBefore.remove(obj);
    if (_listenersAfter.remove(obj)) removed = true;
    return removed;
  }

  bool beforeContains(StateEvents obj) => _listenersBefore.contains(obj);

  bool afterContains(StateEvents obj) => _listenersAfter.contains(obj);

  void dispose() {
    _listenersBefore.removeAll(_listenersBefore);
    _listenersAfter.removeAll(_listenersAfter);
  }
}

class _ControllerListing {
  _ControllerListing([StateMVC state]) {
    _controllers = _ControllerList(state);
  }
  _ControllerList _controllers;

  set controller(ControllerMVC c) {
    add(c);
  }

  ControllerMVC con(String keyId) {
    return _controllers.controller(keyId);
  }

  String add(ControllerMVC c) {
    return _controllers.add(c);
  }

  void addList(List<ControllerMVC> list) =>
      list.forEach((ControllerMVC con) => add(con));

  bool contains(ControllerMVC c) => _controllers.contains(c);

  bool remove(String keyId) => _controllers.remove(keyId);

  List<ControllerMVC> listControllers(List<String> keys) {
    return getControllers(keys).values.toList();
  }

  List<ControllerMVC> get consList => _controllers.asList;
  List<ControllerMVC> get controllerList => consList;

  Map<String, ControllerMVC> getControllers(List<String> keys) {
    Map controllers = Map<String, ControllerMVC>();
    keys.forEach((String key) => controllers[key] = _controllers.map[key]);
    return controllers;
  }

  Map<String, ControllerMVC> get cons => _controllers.map;
  Map<String, ControllerMVC> get controllers => cons;

  void dispose() => _controllers.dispose();
}

class _ControllerList {
  _ControllerList([this.mvcState]);

  StateMVC mvcState;

  final Map<String, ControllerMVC> _map = Map();
  Map<String, ControllerMVC> get map => _map;

  List<ControllerMVC> get asList => _map.values.toList();

  ControllerMVC controller(String keyId) {
    if (keyId == null || keyId.isEmpty) return null;
    return _map[keyId];
  }

  String add(ControllerMVC con) {
    if (con == null) return '';

    /// Already added to this list.
    if (contains(con)) return '';
    bool unassigned = con.stateView == null;
    assert(unassigned, "A Controller can only be assigned to one View!");

    /// If already assigned to another view.
    if (!unassigned) return '';

    /// It's already there?! Return its key.
    if (_map.containsValue(con)) return con._keyId;

    /// This setter connects the State Object! Associates to a View!
    con.stateView = mvcState;
    return _addConId(con, _map);
  }

  bool remove(String keyId) {
    var there = _map[keyId] != null;
    if (there) _map.remove(keyId);
    return there;
  }

  bool contains(ControllerMVC con) => _map.containsValue(con);

  void dispose() => _map.clear();
}

String _addConId(ControllerMVC con, Map<String, ControllerMVC> map) {
  String keyId = _addKeyId(con);
  map[keyId] = con;
  return keyId;
}

String _addKeyId(_StateView sv) {
  String keyId = sv._keyId;
  /// May already have been assigned a key.
  if (keyId.isEmpty) {
    keyId = Uuid().generateV4();
    sv._keyId = keyId;
  }
  return keyId;
}

abstract class StatefulWidgetMVC extends StatefulWidget {
  StatefulWidgetMVC(this.state, {Key key}) : super(key: key);

  /// Expose the state to access!
  final StateMVC state;

  State createState() => state;
}

/// Note: A Widget is marked as [@immutable] so all of the instance fields of this class,
/// whether defined directly or inherited, must be `final`.
abstract class StatedWidget extends StatefulWidgetMVC {
  StatedWidget({Key key}) : super(_StatedState(_StatedController()), key: key);

  /// The build() function you must implement.
  /// It's the View!
  build(BuildContext context);

  void initState() {
    /// The framework will call this method exactly once.
    /// Only when the [State] object is first created.
    ///
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).
  }

  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.
  }

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

  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].
  }

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

  void reassemble() {
    /// Called whenever the application is reassembled during debugging, for
    /// example during hot reload.
    ///
    /// This method should rerun any initialization logic that depends on global
    /// state, for example, image loading from asset bundles (since the asset
    /// bundle may have changed).
  }

  /// Allows the user to call setState() within the Controller.
  void refresh() {
    /// Refresh the interface by 'rebuilding' the Widget Tree
    state.refresh();
  }

  /// The user is free to override with a custom error handler.
  void onError(FlutterErrorDetails details) {
    /// The default routine is to dump the error to the console.
    FlutterError.dumpErrorToConsole(details);
  }
}

class _StatedState extends StateMVC {
  _StatedState(ControllerMVC con) : super(con);

  Widget build(BuildContext context) {
    return (widget as StatedWidget).build(context);
  }
}

/// If there's a new event in StateEvent, update this Class!
class _StatedController extends ControllerMVC {
  StatedWidget _statedWidget;

  @override
  void initState() {
    _statedWidget = widget;
    _statedWidget.initState();
  }

  @override
  void deactivate() {
    _statedWidget.deactivate();
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    _statedWidget.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    _statedWidget.didUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _statedWidget.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeMetrics() {
    _statedWidget.didChangeMetrics();
    super.didChangeMetrics();
  }

  @override
  void didChangeTextScaleFactor() {
    _statedWidget.didChangeTextScaleFactor();
    super.didChangeTextScaleFactor();
  }

  @override
  void didChangeLocale(Locale locale) {
    _statedWidget.didChangeLocale(locale);
    super.didChangeLocale(locale);
  }

  @override
  void didHaveMemoryPressure() {
    _statedWidget.didHaveMemoryPressure();
    super.didHaveMemoryPressure();
  }

  @override
  void didChangeAccessibilityFeatures() {
    _statedWidget.didChangeAccessibilityFeatures();
    super.didChangeAccessibilityFeatures();
  }

  @override
  void didChangeDependencies() {
    _statedWidget.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _statedWidget.reassemble();
    super.reassemble();
  }

  @override
  void onError(FlutterErrorDetails details) => _statedWidget.onError(details);
}

/// Note: A Widget is marked as [@immutable] so all of the instance fields of this class,
/// whether defined directly or inherited, must be `final`.
abstract class StatelessWidgetMVC extends StatelessWidget {
  /// Override this function to produce 'the View!'
  Widget build(BuildContext context);

  StatelessWidgetMVC({Key key}) : super(key: key);

  final _ConInfo conInfo = _ConInfo();

  final _ControllerListing conListing = _ControllerListing();

  ///  ControllerMVC get con => conListing.con;
  ControllerMVC get controller => conInfo.con;

  ///  List<ControllerMVC> get consList => conListing.controllerList;
  List<ControllerMVC> get controllerList => conListing.controllerList;

  ///  Map<String, ControllerMVC> get cons => conListing.cons;
  Map<String, ControllerMVC> get controllers => conListing.cons;

  ///  set con(ControllerMVC c) => conListing.con = c;
  set controller(ControllerMVC c) => add(c);

  String add(ControllerMVC c) {
    String keyId = conListing.add(c);

    /// The first controller is assumed this Widget's controller.
    if (conInfo.con == null) conInfo.con = c;
    return keyId;
  }

  addList(List<ControllerMVC> list) => conListing.addList(list);

  bool remove(String keyId) => conListing.remove(keyId);
}

class _ConInfo {
  ControllerMVC con;
}

abstract class AppMVC extends StatedWidget {
  AppMVC() {
    _running = true;
    initApp();
  }

  /// If this class is running, indicate it so.
  static bool _running = false;

  /// Determine if the 'MVCApp' is being used.
  static String _appStatus = '';

  get states => _states;
  static List<Map<String, StateMVC>> _states = [];

  void initApp() {
    /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  }

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  static Future<bool> init() async {
    return Future.value(true);
  }

  static addState(StateMVC state) {
    state._keyId = Uuid().generateV4();
    if (_appStatus == 'not running') return;
    if (_appStatus.isEmpty) _appStatus = _running ? 'running' : 'not running';
    var map = Map<String, StateMVC>();
    map[state._keyId] = state;
    _states.add(map);
  }

  @mustCallSuper
  void dispose() {
    _running = false;
    _states.clear();
  }

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

///////////////////////////////////////////////////////////////////////////////
// Uuid
// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this Uuid function is governed by the MIT license that can be found
// in the LICENSE file under Uuid.
//
/// A UUID generator, useful for generating unique IDs for your Todos.
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
