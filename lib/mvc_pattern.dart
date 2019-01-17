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

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

/// Controller Class
/// Your 'working' class most concerned with the app's functionality.
abstract class ControllerMVC extends _StateView {
  ControllerMVC([State state]) : super() {
    addState(state);
  }
}

/// View Class
/// Extend and implement its build() function to compose its interface.
abstract class ViewMVC extends _StateView with _ControllerListing {
  /// Implement this build() function to compose the View's interface.
  Widget build(BuildContext context);

  /// Must take in one Controller when this Class instantiates.
  ViewMVC(this.controller) {
    _addKeyId(this);

    // Add this Controller to the Controller Listing!
    controller = controller;
  }
  final ControllerMVC controller;

  /// Setter used to 'add' a Controller to this View.
  set controller(ControllerMVC c) => add(c);

  /// Retrieve a Controller from this View.
  /// Retrieved by using a unique String identifier.
  ControllerMVC con(String keyId) {
    if (_stateMVC == null) {
      return super._con(keyId);
    } else {
      return _stateMVC._con(keyId);
    }
  }

  /// Add a Controller to this View.
  String add(ControllerMVC c) {
    if (_stateMVC == null) {
      return super.add(c);
    } else {
      return _stateMVC.add(c);
    }
  }

  /// Function used to add a list of Controllers to this View.
  void addList(List<ControllerMVC> list) =>
      list.forEach((ControllerMVC con) => add(con));

  /// Determines of ths View already contains this Controller.
  bool contains(ControllerMVC c) {
    if (_stateMVC == null) {
      return super.contains(c);
    } else {
      return _stateMVC.contains(c);
    }
  }

  /// Removes a Controller from this View.
  /// Done by using a unique String identifier.
  bool remove(String keyId) {
    if (_stateMVC == null) {
      return super.remove(keyId);
    } else {
      return _stateMVC.remove(keyId);
    }
  }

  /// Retrieves a list of Controllers from this View.
  /// Done by using a list of unique String identifiers.
  List<ControllerMVC> listControllers(List<String> keys) {
    if (_stateMVC == null) {
      return super.controllers(keys).values.toList();
    } else {
      return _stateMVC.controllers(keys).values.toList();
    }
  }

  /// Retrieves a Map of Controllers from this View.
  /// Done using a list of unique String identifiers.
  Map<String, ControllerMVC> controllers(List<String> keys) {
    if (_stateMVC == null) {
      return super.controllers(keys);
    } else {
      return _stateMVC.controllers(keys);
    }
  }

  /// Called to 'clean up' the List of Controllers and such
  /// associated with this View.
  @protected
  @override
  void dispose() {
    disposeControllerListing();
    super.dispose();
  }
}

class _StateView with StateListener {
  /// Records the current error handler and supplies its own.
  _StateView() : _oldOnError = _recOnError() {
    /// If a tester is running. Don't switch out its error handler.
    if (WidgetsBinding.instance is! TestWidgetsFlutterBinding) {
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
  }

  /// Save the current Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;

  StateMVC get stateView => _stateMVC;

  // VERY IMPORTANT! This setter connects the State Object!
  // Protect this method for now, but maybe later expose it to public classes? -gp
  @protected
  set stateView(StateMVC stateView) {
    assert(_stateMVC == null, "A View is already assigned!");
    _stateMVC = stateView;
    addState(stateView);
  }

  StateMVC _stateMVC;

  List<ControllerMVC> listControllers(List<String> keys) =>
      _stateMVC.listControllers(keys);

  /// Provide the setState() function to external actors
  // Note not 'protected' and so can be called by 'anyone.' -gp
  void setState(fn) {
    _stateMVC?.setState(fn);
  }

  /// Allows external classes to 'refresh' or 'rebuild' the widget tree.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  void refresh() {
    _stateMVC?.refresh();
  }

  /// Add a listener fired 'before' the main controller runs.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  bool addBeforeListener(StateListener obj) {
    return _stateMVC?.addBeforeListener(obj);
  }

  /// Add a listener fired 'after' the main controller runs.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  bool addAfterListener(StateListener obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _stateMVC?.addAfterListener(obj);
  }

  /// Add a listener fired 'after' the main controller runs.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  bool addListener(StateListener obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _stateMVC?.addAfterListener(obj);
  }

  /// Removes a specified listener.
  // Note not 'protected' and so can be called by 'anyone.' -gp
  bool removeListener(Object obj) {
    return _stateMVC?.removeListener(obj);
  }

  /// Dispose the State Object and Controller references.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  @mustCallSuper
  void dispose() {
    /// Return to the original error routine.
    FlutterError.onError = _oldOnError;

    /// The view association is severed.
    _stateMVC = null;
    super.dispose();
  }
}

// TODO If there's a new event, update StatedWidget &  _StatedController! -gp
/// Responsible for the event handling in all the Controllers, Listeners and Views.
/// Could be used as a Mixin.
class StateListener {
  State _state;
  final Set<State> _stateSet = Set();

  void addState(State state) {
    if (state == null) return;
    _state = state;
    _stateSet.add(state);
  }

  bool removeState(State state) {
    if (state == null) return false;
    if (state == _state) return disposeState();
    return _stateSet.remove(state);
  }

  bool disposeState() {
    // Don't continue if null.
    if (_state == null) return false;
    // Remove the 'current' state
    bool removed = _stateSet.remove(_state);
    // Reassign the last state object.
    if (_stateSet.isEmpty) {
      _state = null;
    } else {
      _state = _stateSet.last;
    }
    return removed;
  }

  /// Allow access to the 'StatefulWidget' object.
  StatefulWidget get widget => _widget ?? _state?.widget;
  StatefulWidget _widget;

  /// BuildContext is always useful in the build() function.
  BuildContext get context => _state?.context;

  /// Test to ensure the State Object is 'mounted' and not being terminated.
  bool get mounted => _state?.mounted ?? false;

  /// Provide the setState() function to external actors
  // @protected  Note not 'protected' and so can be called by 'anyone.' -gp
  void setState(fn) {
    /// _state IS a subclass of 'Sate.' Ignore the warning. -gp
    _state?.setState(fn);
  }

  /// Allows external classes to 'refresh' or 'rebuild' the widget tree.
  // @protected  Note not 'protected' and so can be called by 'anyone.' -gp
  void refresh() {
    setState(() {});
  }

  // Assigned an unique key.
  String get keyId => _keyId;
  String _keyId = Uuid().generateV4();

  /// The framework will call this method exactly once.
  /// Only when the [State] object is first created.
  // @protected Note not 'protected' and so can be called by 'anyone.' -gp
  void initState() {
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void deactivate() {
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  /// The framework calls this method when this [State] object will never
  /// build again. The [State] object's lifecycle is terminated.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    /// The state reference is removed.
    disposeState();
  }

  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
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
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
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
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void didChangeLocale(Locale locale) {
    /// Called when the system tells the app that the user's locale has
    /// changed. For example, if the user changes the system language
    /// settings.
    ///
    /// This method exposes notifications from [Window.onLocaleChanged].
  }

  /// Called when the system is running low on memory.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void didHaveMemoryPressure() {
    /// Called when the system is running low on memory.
    ///
    /// This method exposes the `memoryPressure` notification from
    /// [SystemChannels.system].
  }

  /// Called when the system changes the set of active accessibility features.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void didChangeAccessibilityFeatures() {
    /// Called when the system changes the set of currently active accessibility
    /// features.
    ///
    /// This method exposes notifications from [Window.onAccessibilityFeaturesChanged].
  }

  /// Called when a dependency of this [State] object changes.
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
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
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
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
  // @protected   Note not 'protected' and so can be called by 'anyone.' -gp
  void onError(FlutterErrorDetails details) =>
      FlutterError.dumpErrorToConsole(details);
}

/// The State Object with an Error Handler in its build() function.
abstract class StateViewMVC extends StateMVC {
  /// Takes in a View and passes the View's Controller to the parent class.
  StateViewMVC(this.view) : super(view.controller) {
    assert(view != null, "View can't be null! Pass a view to StateViewMVC.");

    /// IMPORTANT! Add the View's controllers first before calling setter. -gp
    addList(view._controllerList);

    /// TODO What is this function called here?
    view.disposeControllerListing();

    /// IMPORTNANT! This setter connects the State Object!
    view.stateMVC = this; // _ControllerListing
    view.stateView = this; // _StateView
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

/// Main State Object seen as the 'StateView.'
abstract class StateMVC<T extends StatefulWidget> extends State<StatefulWidget>
    with WidgetsBindingObserver, _ControllerListing, _StateListener {
  /// The View!
  Widget build(BuildContext context);

  /// You need to be able access the widget.
  T get widget => super.widget;

  /// Record the 'default' error handler for Flutter.
  static final _defaultError = FlutterError.onError;

  /// With an optional Controller parameter, this constructor imposes its own Errror Handler.
  StateMVC([ControllerMVC _con]) : _oldOnError = _recOnError() {
    /// If a tester is running. Don't switch out its error handler.
    if (WidgetsBinding.instance is! TestWidgetsFlutterBinding) {
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
    }

    /// IMPORTANT! Assign itself to stateView before adding any Controller. -gp
    stateMVC = this;
    add(_con);
  }

  /// Save the original Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;

//  /// Assign a specified controller to this View.
//  set controller(ControllerMVC c) {
//    // Must remove a possibly listener. -gp
//    add(c);
//  }

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

  bool addBeforeListener(StateListener obj) {
    /// Assign this state.
    obj.addState(this);
    return super.addBeforeListener(obj);
  }

  bool addAfterListener(StateListener obj) {
    /// Assign this state.
    obj.addState(this);
    return super.addAfterListener(obj);
  }

  bool removeListener(StateListener obj) {
    obj.removeState(this);
    return super.removeListener(obj);
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
    AppMVC._addState(this);

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _controllerList.forEach((ControllerMVC con) => con._widget = widget);
    _beforeList.forEach((StateListener obj) => obj.initState());
    _controllerList.forEach((ControllerMVC con) => con.initState());
    _afterList.forEach((StateListener obj) => obj.initState());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.deactivate());
    _controllerList.forEach((ControllerMVC con) => con.deactivate());
    _afterList.forEach((StateListener obj) => obj.deactivate());
    super.deactivate();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.dispose());
    _controllerList.forEach((ControllerMVC con) => con.dispose());
    disposeControllerListing();
    _afterList.forEach((StateListener obj) => obj.dispose());
    disposeStateEventList();

    /// Should not be 'rebuilding' anyway. This Widget is going away.
    _rebuildAllowed = true;
    _rebuildRequested = false;
    WidgetsBinding.instance.removeObserver(this);

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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didUpdateWidget(oldWidget));
    _controllerList
        .forEach((ControllerMVC con) => con.didUpdateWidget(oldWidget));
    _afterList.forEach((StateListener obj) => obj.didUpdateWidget(oldWidget));
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList
        .forEach((StateListener obj) => obj.didChangeAppLifecycleState(state));
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAppLifecycleState(state));
    _afterList
        .forEach((StateListener obj) => obj.didChangeAppLifecycleState(state));
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didChangeMetrics());
    _controllerList.forEach((ControllerMVC con) => con.didChangeMetrics());
    _afterList.forEach((StateListener obj) => obj.didChangeMetrics());
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didChangeTextScaleFactor());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeTextScaleFactor());
    _afterList.forEach((StateListener obj) => obj.didChangeTextScaleFactor());
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didChangeLocale(locale));
    _controllerList.forEach((ControllerMVC con) => con.didChangeLocale(locale));
    _afterList.forEach((StateListener obj) => obj.didChangeLocale(locale));
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didHaveMemoryPressure());
    _controllerList.forEach((ControllerMVC con) => con.didHaveMemoryPressure());
    _afterList.forEach((StateListener obj) => obj.didHaveMemoryPressure());
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

    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList
        .forEach((StateListener obj) => obj.didChangeAccessibilityFeatures());
    _controllerList
        .forEach((ControllerMVC con) => con.didChangeAccessibilityFeatures());
    _afterList
        .forEach((StateListener obj) => obj.didChangeAccessibilityFeatures());
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called when a dependency of this [State] object changes.
  @protected
  @override
  @mustCallSuper
  void didChangeDependencies() {
    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.didChangeDependencies());
    _controllerList.forEach((ControllerMVC con) => con.didChangeDependencies());
    _afterList.forEach((StateListener obj) => obj.didChangeDependencies());
    super.didChangeDependencies();
    _rebuildAllowed = true;
    if (_rebuildRequested) {
      _rebuildRequested = false;

      /// Perform a 'rebuild' if requested.
      refresh();
    }
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @protected
  @mustCallSuper
  @override
  void reassemble() {
    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _beforeList.forEach((StateListener obj) => obj.reassemble());
    _controllerList.forEach((ControllerMVC con) => con.reassemble());
    _afterList.forEach((StateListener obj) => obj.reassemble());
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
  // Note not 'protected' and so can be called by 'anyone.' -gp
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
class _StateListener {
  List<StateListener> get _beforeList => _listenersBefore.toList();
  List<StateListener> beforeList(List<String> keys) {
    return _getList(keys, _listenersBefore);
  }

  final Set<StateListener> _listenersBefore = Set();

  List<StateListener> get _afterList => _listenersAfter.toList();
  List<StateListener> afterList(List<String> keys) {
    return _getList(keys, _listenersAfter);
  }

  final Set<StateListener> _listenersAfter = Set();

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

  bool addBeforeListener(StateListener obj) {
    /// Add a listener fired 'before' the main controller runs.
    return _listenersBefore.add(obj);
  }

  bool addAfterListener(StateListener obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _listenersAfter.add(obj);
  }

  bool addListener(StateListener obj) {
    /// Add a listener fired 'after' the main controller runs.
    return addAfterListener(obj);
  }

  bool removeListener(StateListener obj) {
    bool removed = _listenersBefore.remove(obj);
    if (_listenersAfter.remove(obj)) removed = true;
    return removed;
  }

  bool beforeContains(StateListener obj) => _listenersBefore.contains(obj);

  bool afterContains(StateListener obj) => _listenersAfter.contains(obj);

  StateListener beforeListener(String key) {
    return _getStateEvents(key, _listenersBefore);
  }

  StateListener afterListener(String key) {
    return _getStateEvents(key, _listenersAfter);
  }

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

  void disposeStateEventList() {
    _listenersBefore.clear();
    _listenersAfter.clear();
  }
}

class _ControllerListing {
  _ControllerList _controllers = _ControllerList();

  set stateMVC(StateMVC stateMVC) {
    bool unassigned = _controllers.mvcState == null;
    assert(unassigned, "Already assigned a 'StateView!'");
    if (unassigned) _controllers.mvcState = stateMVC;
  }

  // Don't use this one so subclasses to use 'con.'
//  set controller(ControllerMVC c) {
//    add(c);
//  }

  // Keep it private to allow subclasses to use 'con.'
  ControllerMVC _con(String keyId) {
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
    return controllers(keys).values.toList();
  }

  /// Never supply a public list of Controllers. User must know the key identifier(s).
  List<ControllerMVC> get _controllerList => _controllers.asList;

  Map<String, ControllerMVC> controllers(List<String> keys) {
    Map<String, ControllerMVC> controllers = {};
    keys.forEach((String key) => controllers[key] = _controllers.map[key]);
    return controllers;
  }

// Not being used. I think. Deprecated
//  /// Never supply a public list of Controllers. User must know the key identifier(s).
//  Map<String, ControllerMVC> get _cons => _controllers.map;

  void disposeControllerListing() => _controllers.dispose();
}

class _ControllerList {
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

    /// It's being passed in again. It happens. Simply return key id.
    if (con.stateView != null && con.stateView == mvcState) return con._keyId;

    bool unassigned = con.stateView == null;
    assert(unassigned, "A Controller can only be assigned to one View!");

    /// Return blank in production.
    /// If already assigned to another view.
    if (!unassigned) return '';

    /// This setter connects the State Object! Associates to a View!
    con.stateView = mvcState;

    /// It's already there?! Return its key.
    return (contains(con)) ? con._keyId : _addConId(con, _map);
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

/// Main or first class to pass to the 'main.dart' file's runApp() function.
///    Example:  void main() => runApp(MyApp());
abstract class AppMVC extends StatefulWidget {
  /// Simple constructor. Calls the initApp() function.
  AppMVC({this.con, Key key}) : super(key: key);
  final ControllerMVC con;

  /// Create the View!
  Widget build(BuildContext context);

  @override
  State createState() => _AppState(con);

  /// Determine if the 'MVCApp' is being used.
  static String _appStatus = '';

  static List<Map<String, StateMVC>> states = [];

  /// Returns a StateView object using a unique String identifier.
  // There's a better way. Just too tired now.
  StateMVC getState(String keyId) {
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
  Map<String, StateMVC> getStates(List<String> keys) {
    Map map = Map<String, StateMVC>();
    keys.forEach((String key) {
      StateMVC sv = getState(key);
      if (sv != null) map[key] = sv;
    });
    return map;
  }

  /// Returns a List of StateView objects using unique String identifiers.
  List<StateMVC> listStates(List<String> keys) {
    return getStates(keys).values.toList();
  }

  /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  void initApp() {}

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  Future<bool> init() async {
    return Future.value(true);
  }

  /// This is 'privatized' as it is an critical method and not for public access.
  static _addState(StateMVC state) {
    if (_appStatus == 'not running') return;
    if (_appStatus.isEmpty)
      _appStatus = _AppState.running ? 'running' : 'not running';
    var map = Map<String, StateMVC>();
    map[state._keyId] = state;
    states.add(map);
  }

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

class _AppState extends StateMVC<AppMVC>{
  _AppState(ControllerMVC con): super(con);

  void initState() {
    running = true;
    widget.initApp();
    // Preform the init first.
//    add(widget.con);
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
    AppMVC.states.clear();
    super.dispose();
  }
}

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
