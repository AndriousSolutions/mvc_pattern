library mvc_pattern;
///
/// Copyright (C) 2018 Andrious Solutions Ltd.
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  08 Oct 2018
///
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// You've got to extend this class to create a Controller
abstract class MVController extends StateEvents {

  MVController(): super();

  /// The View is a State object after all.
  State get state => _state;
  MVCState get stateView => _stateView;
  set stateView(MVCState state){
    assert(_stateView == null, "A View is already assigned!");
    _stateView = state;
    _state = state;
  }
  MVCState _stateView;

  /// Allow for the widget getter in the build() function.
  StatefulWidget get widget => _widget ?? _state?.widget;
  set widget(StatefulWidget w) {
    assert(_widget == null, "A Widget is already assigned!");
    _widget = w;
  }
  StatefulWidget _widget;

  /// BuildContext is always useful in the build() function.
  BuildContext get context => _state?.context;

  /// Ensure the State Object is 'mounted' and not being terminated.
  bool get mounted => _state?.mounted ?? false;

  /// The controller is assigned an unique key.
  String get keyId => _keyId;
  String _keyId = '';

  List<MVController> listControllers(List<String> keys) => _stateView.listControllers(keys);

  /// Provide the setState() function to the build() function.
  setState(fn) {
    _stateView?.setState(fn);
  }

  refresh(){
    _stateView?.refresh();
  }

  bool addBeforeListener(StateEvents obj){
    /// Add a listener fired 'before' the main controller runs.
    return _stateView?.addBeforeListener(obj);
  }

  bool addAfterListener(StateEvents obj){
    /// Add a listener fired 'after' the main controller runs.
    return _stateView?.addAfterListener(obj);
  }

  bool addListener(StateEvents obj) {
    /// Add a listener fired 'after' the main controller runs.
    return _stateView?.addAfterListener(obj);
  }

  bool removeListener(Object obj) {
    return _stateView?.removeListener(obj);
  }

  @override
  @mustCallSuper
  void dispose() {
    /// The framework calls this method when this [State] object will never
    /// build again. The [State] object's lifecycle is terminated.
    /// Subclasses should override this method to release any resources retained
    /// by this object (e.g., stop any active animations).

    /// The view association is severed.
    _stateView = null;
    _state = null;
    super.dispose();
  }
}



class StateEvents {

  StateEvents(): _oldOnError = _recError() {
    /// This allows you to place a breakpoint at 'onError(details)' to determine error location.
    FlutterError.onError = (FlutterErrorDetails details) {
      onError(details);
    };
  }
  /// Save the current Error Handler.
  final Function(FlutterErrorDetails details) _oldOnError;
  static final _defaultError = FlutterError.onError;

  /// Allow for a reference to the State object.
  State _state;

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
  void onError(FlutterErrorDetails details) => FlutterError.dumpErrorToConsole(details);

  static Function(FlutterErrorDetails details) _recError(){
    var func;
    /// If it's not the 'default' routine, you better save it.
    if(FlutterError.onError != _defaultError){
      func = FlutterError.onError;
    }else{
      func = _defaultError;
    }
    return func;
  }
}



abstract class MVCState extends State<StatefulWidget>
    with WidgetsBindingObserver {

  /// The View!
  Widget build(BuildContext context);

  MVCState([MVController _con]):_oldError = _recError(){
    /// This allows one to place a breakpoint at 'onError(details)' to determine error location.
    FlutterError.onError = (FlutterErrorDetails details) {
      onError(details);
    };
    _eventHandler = _StateEventList(this);
    _conListing = _ControllerListing(this);
    add(_con);
  }
  /// Save the original Error Handler.
  final Function(FlutterErrorDetails details) _oldError;
  static final _defaultError = FlutterError.onError;

  /// Contains a listing of all the Controllers assigned to this View.
  _ControllerListing _conListing ;

  MVController con(String keyId) => _conListing.con(keyId);

  Map<String, MVController> controllers(List<String> keys) => _conListing.getControllers(keys);

  List<MVController> get _controllerList => _conListing.controllerList;
  List<MVController> listControllers(List<String> keys) => _conListing.listControllers(keys);

  set controller(MVController c){
    add(c);
  }

  String add(MVController c){
    /// It may have been a listener. Can't be both.
    bool removed = removeListener(c);
    assert(!removed, "Removed Listener as it is now a Contoller!");
    return _conListing.add(c);
  }

  void addList(List<MVController> list) => _conListing.addList(list);

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
    MVCApp.addState(this);
    /// No 'setState()' functions are allowed to fully function at the point.
    _rebuildAllowed = false;
    _controllerList.forEach((MVController con) => con.widget = widget);
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.initState());
    _controllerList.forEach((MVController con) => con.initState());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.initState());
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _controllerList.forEach((MVController con) => con.deactivate());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.deactivate());
    super.deactivate();
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _controllerList.forEach((MVController con) => con.dispose());
    _conListing.dispose();
    _eventHandler.afterList.forEach((StateEvents obj) => obj.dispose());
    _eventHandler.dispose();
    /// Should not be 'rebuilding' anyway. This Widget is going away.
    _rebuildAllowed = true;
    _rebuildRequested = false;
    WidgetsBinding.instance.removeObserver(this);
    /// Return the original error routine.
    FlutterError.onError = _oldError;
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didUpdateWidget(oldWidget));
    _controllerList.forEach((MVController con) => con.didUpdateWidget(oldWidget));
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didUpdateWidget(oldWidget));
    super.didUpdateWidget(oldWidget);
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeAppLifecycleState(state));
    _controllerList.forEach((MVController con) => con.didChangeAppLifecycleState(state));
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeAppLifecycleState(state));
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeMetrics());
    _controllerList.forEach((MVController con) => con.didChangeMetrics());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeMetrics());
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeTextScaleFactor());
    _controllerList.forEach((MVController con) => con.didChangeTextScaleFactor());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeTextScaleFactor());
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeLocale(locale));
    _controllerList.forEach((MVController con) => con.didChangeLocale(locale));
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeLocale(locale));
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didHaveMemoryPressure());
    _controllerList.forEach((MVController con) => con.didHaveMemoryPressure());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didHaveMemoryPressure());
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeAccessibilityFeatures());
    _controllerList.forEach((MVController con) => con.didChangeAccessibilityFeatures());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeAccessibilityFeatures());
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _eventHandler.beforeList.forEach((StateEvents obj) => obj.didChangeDependencies());
    _controllerList.forEach((MVController con) => con.didChangeDependencies());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.didChangeDependencies());
    super.didChangeDependencies();
    _rebuildAllowed = true;
    if(_rebuildRequested){
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
    _controllerList.forEach((MVController con) => con.reassemble());
    _eventHandler.afterList.forEach((StateEvents obj) => obj.reassemble());
    super.reassemble();
    _rebuildAllowed = true;
    if(_rebuildRequested){
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

    if(_rebuildAllowed) {
      /// Call the State object's setState() function.
      super.setState(fn);
    }else{
      /// Can't rebuild at this moment but at least make the request.
      _rebuildRequested = true;
    }
  }

  /// Allows the user to call setState() within the Controller.
  void refresh() {
    /// Refresh the interface by 'rebuilding' the Widget Tree
    setState((){});
  }

  /// Supply an 'error handler' routine to fire when an error occurs.
  /// Allows the user to define their own with each Controller.
  /// The default routine is to dump the error to the console.
  // details.exception, details.stack
  void onError(FlutterErrorDetails details) => FlutterError.dumpErrorToConsole(details);
  
  static Function(FlutterErrorDetails details) _recError(){
    var func;
    /// If it's not the 'default' routine, you better save it.
    if(FlutterError.onError != _defaultError){
      func = FlutterError.onError;
    }else{
      func = _defaultError;
    }
    return func;
  }
}



class _StateEventList{

  _StateEventList(this.view);

  final MVCState view;

  final Set<StateEvents> _listenersBefore = Set();
  List<StateEvents> get beforeList => _listenersBefore.toList();

  final Set<StateEvents> _listenersAfter = Set();
  List<StateEvents> get afterList => _listenersAfter.toList();

  bool addBefore(StateEvents obj){
    return _listenersBefore.add(obj);
  }

  bool addAfter(StateEvents obj){
    return _listenersAfter.add(obj);
  }

  bool remove(StateEvents obj){
    bool removed;
    removed = _listenersBefore.remove(obj);
    if(_listenersAfter.remove(obj)) removed = true;
    return removed;
  }

  bool beforeContains(StateEvents obj) => _listenersBefore.contains(obj);

  bool afterContains(StateEvents obj) => _listenersAfter.contains(obj);


  void dispose(){
    _listenersBefore.removeAll(_listenersBefore);
    _listenersAfter.removeAll(_listenersAfter);
  }
}



class _ControllerListing {

  _ControllerListing([MVCState state]) {
    _controllers = _ControllerList(state);
  }
  _ControllerList _controllers;

  set controller(MVController c) {
    add(c);
  }

  MVController con(String keyId){
    return _controllers.controller(keyId);
  }

  String add(MVController c){
    return _controllers.add(c);
  }

  void addList(List<MVController> list) => list.forEach((MVController con) => add(con));

  bool contains(MVController c) => _controllers.contains(c);

  bool remove(String keyId) => _controllers.remove(keyId);

  List<MVController> listControllers(List<String> keys){
    return getControllers(keys).values.toList();
  }

  List<MVController> get consList => _controllers.asList;
  List<MVController> get controllerList => consList;

  Map<String,MVController> getControllers(List<String> keys){
    Map controllers = Map<String, MVController>();
    keys.forEach((String key) => controllers[key] = _controllers.map[key]);
    return controllers;
  }

  Map<String,MVController> get cons => _controllers.map;
  Map<String,MVController> get controllers => cons;

  void dispose() => _controllers.dispose();
}



class _ControllerList{

  _ControllerList([this.mvcState]);

  MVCState mvcState;

  final Map<String, MVController> _map = Map();
  Map<String, MVController> get map => _map;

  List<MVController> get asList => _map.values.toList();

  MVController controller(String keyId){
    return _map[keyId];
  }

  String add(MVController con){
    if(con == null) return '';
    /// Already added to this list.
    if(contains(con)) return '';
    bool unassigned = con.stateView == null;
    assert(unassigned, "A Controller can only be assigned to one View!");
    /// If already assigned to another view.
    if(!unassigned) return '';
    if(_map.containsValue(con))return '';
    /// associate it with this particular view.
    con.stateView = mvcState;
    var keyId = Uuid().generateV4();
    con._keyId = keyId;
    _map[keyId] = con;
    return keyId;
  }

  bool remove(String keyId) {
    var there = _map[keyId] != null;
    if(there) _map.remove(keyId);
    return there;
  }

  bool contains(MVController con) => _map.containsValue(con);

  void dispose() => _map.clear();
}



/// Note: A Widget is marked as [@immutable] so all of the instance fields of this class,
/// whether defined directly or inherited, must be `final`.
abstract class StatelessWidgetMVC extends StatelessWidget {

  /// Override this function to produce 'the View!'
  Widget build(BuildContext context);

  StatelessWidgetMVC({Key key}): super(key: key);

  final _ConInfo conInfo = _ConInfo();

  final _ControllerListing conListing = _ControllerListing();

  ///  MVController get con => conListing.con;
  MVController get controller => conInfo.con;

  ///  List<MVController> get consList => conListing.controllerList;
  List<MVController> get controllerList => conListing.controllerList;

  ///  Map<String, MVController> get cons => conListing.cons;
  Map<String, MVController> get controllers => conListing.cons;

  ///  set con(MVController c) => conListing.con = c;
  set controller(MVController c) => add(c);

  String add(MVController c){
    String keyId = conListing.add(c);
    /// The first controller is assumed this Widget's controller.
    if(conInfo.con == null) conInfo.con = c;
    return keyId;
  }

  addList(List<MVController> list) => conListing.addList(list);

  bool remove(String keyId) => conListing.remove(keyId);
}

class _ConInfo{
  MVController con;
}


abstract class StatefulWidgetMVC extends StatefulWidget{

  StatefulWidgetMVC(this.state, {Key key}): super(key: key);
  /// Expose the state to access!
  final MVCState state;

  State createState() => state;
}



/// Note: A Widget is marked as [@immutable] so all of the instance fields of this class,
/// whether defined directly or inherited, must be `final`.
abstract class StatedWidget extends StatefulWidgetMVC{

  StatedWidget({Key key}): super(StatedState(StatedController()),key: key);

  /// The build() function you must implement.
  /// It's the View!
  build(BuildContext context);

  void initState(){
    /// The framework will call this method exactly once.
    /// Only when the [State] object is first created.
    ///
    /// Override this method to perform initialization that depends on the
    /// location at which this object was inserted into the tree.
    /// (i.e. Subscribe to another object it depends on during [initState],
    /// unsubscribe object and subscribe to a new object when it changes in
    /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  }

  void deactivate(){
    /// The framework calls this method whenever it removes this [State] object
    /// from the tree. It might reinsert it into another part of the tree.
    /// Subclasses should override this method to clean up any links between
    /// this object and other elements in the tree (e.g. if you have provided an
    /// ancestor with a pointer to a descendant's [RenderObject]).
  }

  void dispose(){
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
  void refresh(){
    /// Refresh the interface by 'rebuilding' the Widget Tree
    state.refresh();
  }

  /// The user is free to override with a custom error handler.
  void onError(FlutterErrorDetails details){
    /// The default routine is to dump the error to the console.
    FlutterError.dumpErrorToConsole(details);
  }
}



class StatedState extends MVCState {

  StatedState(MVController con):super(con);

  Widget build(BuildContext context){
    return (widget as StatedWidget).build(context);
  }
}



class StatedController extends MVController{

  StatedWidget _statefulWidget;

  @override
  void initState(){
    _statefulWidget = widget;
    _statefulWidget.initState();
  }

  @override
  void deactivate(){
    _statefulWidget.deactivate();
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose(){
    _statefulWidget.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    _statefulWidget.didUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _statefulWidget.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    _statefulWidget.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _statefulWidget.reassemble();
    super.reassemble();
  }

  @override
  void onError(FlutterErrorDetails details) => _statefulWidget.onError(details);
}


abstract class MVCApp extends StatedWidget{

  MVCApp(){
    _running = true;
    initApp();
  }
  /// If this class is running, indicate it so.
  static bool _running = false;
  /// Determine if the 'MVCApp' is being used.
  static String _appStatus = '';

  get states => _states;
  static List<Map<String, MVCState>> _states = [];

  void initApp(){
    /// Initialize any immediate 'none time-consuming' operations at the very beginning.
  }

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize items essential to the Mobile Applications.
  /// Called by the MVCApp.init() function.
  @mustCallSuper
  static Future<bool> init() async {
    return Future.value(true);
  }

  static addState(MVCState state){
    state._keyId = Uuid().generateV4();
    if (_appStatus == 'not running') return;
    if (_appStatus.isEmpty) _appStatus = _running ? 'running' : 'not running';
    var map = Map<String, MVCState>();
    map[state._keyId] = state;
    _states.add(map);
  }

  @mustCallSuper
  void dispose(){
    _running = false;
    _states.clear();
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

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