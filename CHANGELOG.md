

## 8.6.0
 January 22, 2022
- testsStateListener02(tester); testsStateListener02(tester); resetPage1Count(tester);
- AppStateMVC.deactivate(); to AppStateMVC.dispose();

## 8.5.2+01
 January 17, 2022
- Rewrote 'pop state' _popState()
- Removed _popState() from deactivate()
- _AppStateMVC class merged into AppStateMVC class

## 8.5.1+01
 January 17, 2022
- integration_test: in mvc_pattern
- Introduced test_listener.dart
- isInstanceOf is isA
- import 'package:integration_test/integration_test.dart';

## 8.5.1
 January 16, 2022
- Resolved 'no_logic_in_create_state' issue in 'Root StatefulWidget'

## 8.5.0+02
 January 15, 2022
- Include pubspec.yaml in example app
- flutter_test in dev_dependencies and dependencies

## 8.5.0
 January 15, 2022
- bool _pushState(StateMVC? state) assign only if not already pushed
- addList(List<ControllerMVC>? list) returns a List of keyId's
- mixin _ControllerListing._controllers renamed _controllersMap
- get firstCon renamed rootCon for consistency with rootState
- Removed parameter controller from class AppStatefulWidgetMVC
- Removed get context from class AppStatefulWidgetMVC
- Removed static getState() from class AppStatefulWidgetMVC
- Removed initApp() from class AppStatefulWidgetMVC
- Clean up memory in AppStateMVC.deactivate()
- Reduced to one state reference: AppStateMVC? _rootStateMVC;
- Replaced package:pedantic in analysis_options.yaml
- Incorporated example app to widget_test.dart

## 8.4.0
 January 12, 2022
- Privatize properties in the example app
- AppStatefulWidgetMVC({Key? key, this.con}) to this.controller
- ControllerMVC? controllerById(String? keyId) =>
- this.controllers to List<ControllerMVC>? controllers in AppStateMVC

## 8.3.0
 January 09, 2022
- New example app
- Map<Type, Object> _controllers = {} to Set<ControllerMVC> _controllers = {};
- futureBuilt to _futureBuilt
- final controllers = AppStatefulWidgetMVC._controllers.toList();
- mixin _RootStateMixin
- StateMVC? stateOf<T extends StatefulWidget>()
- Working on test

## 8.2.2.+03
 December 31, 2021
- Update .github/workflows/

## 8.2.2
 December 25, 2021
- Future<bool> didPopRoute() async => false; Future<bool> didPushRoute(String route) async => false;

## 8.2.1
 December 10, 2021
- context?.findAncestorStateOfType<T>();

## 8.2.0
 November 24, 2021
- Replaced setStatesInherited with inheritedNeedsBuild();

## 8.1.2
 November 22, 2021
- In void deactivate() { for (final con in _beforeList) {

## 8.1.1
 November 10, 2021
- // Don't if the widget is not in the widget tree.
- if (mounted) {

## 8.1.0
 November 04, 2021
- StateMVC? get state => _stateMVC; replaces getter, stateMVC
- pedantic 1.11.1 (discontinued replaced by lints)

## 8.0.0
 October 30, 2021
- Remove deprecated function, removeState()
- Removed from mixin StateListener: initAsync() & onAsyncError()
- Renamed ViewMVC to AppStateMVC
- Renamed AppConMVC to AppControllerMVC
- AppControllerMVC is now a mixin
- Renamed AppMVC to AppStatefulWidgetMVC
- Nullify ControllerMVC? get controller => _controller ??= firstCon;
- Nullify ControllerMVC? get firstCon => _asList.first;
- Rewritten class _InheritedMVC extends StatefulWidget {

## 7.4.0
 July 08, 2021
- StateMVC.of<T>(context);

## 7.3.3
 June 24, 2021
- if (_statePushed) { // Retain the 'right' State object.

## 7.3.2
 June 24, 2021
- _stateMVCSet.retainWhere((state) => state.mounted);

## 7.3.1
 June 24, 2021
- setState() only if (mounted) {

## 7.3.0+2
 June 11, 2021
- Introduced ofState() in mixin StateSets

## 7.2.0
 May 01, 2021
- _inTester = WidgetsBinding.instance is TestWidgetsFlutterBinding;

## 7.1.4
 April 19, 2021
- Don't continue app if !con.initAsync();

## 7.1.3
 March 30, 2021
- Corrected _removeStateMVC(StateMVC? state)
- Enhanced BuildContext? get context
- Removed deprecated function, popState().

## 7.1.2
 March 27, 2021
- class _InheritedMVC with Object? object;
- catchError() has WidgetsBinding.instance is WidgetsFlutterBinding
- Unit Tests for class ViewMVC & class _InheritedMVC
- Separate tests files.

## 7.1.1
 March 26, 2021
- Further Unit Tests
- Corrected beforeList() & afterList() with for (final listener in set) {

## 7.1.0
 March 21, 2021
- **BREAKING CHANGE** addState() returns State object's unique identifier; not the controller's
- Corrected AppMVC._addStateMVC(this as StateMVC);
- Removed deprecated function, popState()
- Improved test widget
- Introduced CI/CD with Github Actions
- Introduced Test coverage with Codecov

## 7.0.1
 March 21, 2021
- for (final listener in set) {

## 7.0.0   Null safety
 March 04, 2021
- Migrated to Dart SDK 2.12.0

## 6.6.4+2
 January 25, 2021
- AppMVC._removeStateMVC(this);
- BuildContext get context

## 6.6.3+2
 January 08, 2021
- Updated README.md to include mvc_application.

## 6.6.3
 January 08, 2021
- _rebuildAllowed = true; in dispose();

## 6.6.2
 November 21, 2020
- **Critical fix** _rebuildAllowed = true; in initAsync()

## 6.6.1
 November 21, 2020
- Commented out , if (mounted), in refresh()

## 6.6.0
 November 09, 2020
- New method onAsyncError(FlutterErrorDetails details)

## 6.5.0
 October 10, 2020
- Removed deprecated function, buildView();

## 6.4.0
 September 07, 2020
- Introduced class, ModelMVC
- Introduced class, StateSetter
- Introduced mixin, StateSets
- Removed key from class, ViewMVC

## 6.3.0
 August 14, 2020
- Remove import 'package:flutter_test/flutter_test.dart' to support Flutter Web 

## 6.2.0+1
 August 14, 2020
- ControllerMVC controller in class, ViewMVC

## 6.2.0
 August 13, 2020
- Strict Flutter Lint Rules following Dart Style Guide.
- Introduced analysis_options.yaml

## 6.1.3+2
 July 10, 2020
- Corrected the README.md
 
## 6.1.0
 July 09, 2020
- @deprecated  Widget buildView(BuildContext context);
- README  Note, there is now the 'MVC framework' which wraps around this
- Remove 'author' section from pubspec.yaml

## 6.0.0
 May 18, 2020
- Fixed controllerByType(); AppMVC.controllers to AppMVC._controllers

## 5.1.1
 May 02, 2020
- @mustCallSuper to didChangeMetrics() didChangeTextScaleFactor() didChangeLocale() 
- didHaveMemoryPressure() didChangeAccessibilityFeatures() didChangeDependencies() reassemble() 

## 5.1.0
 April 26, 2020
- AppConMVC(state) provide the state parameter.
- AppState should not rebuild.

## 5.0.0
 April 19, 2020
- Future<bool> initAsync() async in mixin StateListener
- Removed Future<bool> init() async in class AppConMVC
- Replaced  Future<bool>.value(true) in didPopRoute(), didPushRoute(), 
  
## 4.0.0
 April 07, 2020
- Introduced integrated error handling. 
- ViewMVC remove errorScreen, 
- AppConMVC stateMVC?.onError(details)
- AppMVC void onError(details)

## 3.8.0
 February 26, 2020
- Returned the getter, context, to the Controller.
 
## 3.7.2
 January 22, 2019
- **Correction** Don't call Controller's dispose in StateMVC if it's in other State objects.

## 3.7.1
 January 16, 2020
- errorScreen == null

## 3.7.0
 January 16, 2020
- Custom 'Error Screen' instead of 'Red Screen of Death'

## 3.6.1
 December 30, 2019
- Don't dispose Controller if it's in other State objects.

## 3.6.0
 December 06, 2019
- void catchError(Exception ex)
- context.dependOnInheritedWidgetOfExactType
- assert(this.mounted, "StateMVC is not instantiated properly.");
- SDK constraints sdk: ">=2.3.0 <3.0.0"

## 3.5.0
 Sept. 20, 2019
- New functions, rebuild() notifyListeners() calls refresh()
- T controllerByType<T extends ControllerMVC>(
- abstract class ViewMVC<T extends StatefulWidget> extends StateMVC<T> {
- class _InheritedMVC<T extends Object> extends InheritedWidget {
- class SetState extends StatelessWidget {
 
## 3.4.3
 Sept. 02, 2019
- _AppState super.initState();
- SDK constraints sdk: ">=2.2.2 <3.0.0"
 
## 3.4.2
 August 23, 2019
- states property in AppMVC set to private, _states.

## 3.4.1
 July 02, 2019
- Flutter upgrade
- _rebuildAllowed = true; after super.deactivate(); super.didUpdateWidget(oldWidget); super.reassemble();

## 3.4.0
 July 02, 2019
- of() function introduced. 
- expect() functions in mvc_pattern_test.dart

## 3.3.8
 June 28, 2019
- **Bug fix** _rebuildAllowed = true; in StateMVC.deactivate()

## 3.3.7
 May 11, 2019
- StateMVC.dispose() will only run once.  Removed if(_disposed) return;

## 3.3.6
 Apr. 21, 2019
- Ensure StateMVC.dispose() is runs only once.  if(_disposed) return;

## 3.3.5
 Apr. 12, 2019
- Return _rebuildAllowed = true; in didUpdateWidget() & reassemble()

## 3.3.4
 Apr. 03, 2019
- **Correction** Controllers and Listeners dispose calls in the StateMVC were not an issue after all.

## 3.3.3
 Apr. 02, 2019
- Call _disposeState() on all controllers when StateMVC is disposed.

## 3.3.2
 Apr. 02, 2019
- Proven prudent to not dispose any Controllers or Listeners in the StateMVC.
 
## 3.3.1
 Apr. 02, 2019
- ControllerMVC getter 'states' returns a 'copy' of the Set of State objects. 
- Only dispose a Controller if no longer relied on by a view.

## 3.3.0 
 Mar. 16, 2019. 
- Removed abstract from class ControllerMVC
- Add didPopRoute() didPushRoute() to StateListener

## 3.2.4 
 Mar. 02, 2019. 
- No 'setState()' function is necessary; in some events.

## 3.2.3 
 Feb. 20, 2019. 
- await (con as AppConMVC)?.init();

## 3.2.2 
 Feb. 17, 2019. 
- _oldOnError = _recOnError()

## 3.2.1 
 Feb. 06, 2019. 
- Update the upper bound of the SDK constraint to <3.0.0

## 3.2.0 
 Jan. 30, 2019. 
- Deprecated Error Handler from Controller. Removed refresh(); from initState() & deactiveate

## 3.1.0 
 Jan. 26, 2019. 
- StateViewMVC implements StateListener & get controller 
 
## 3.0.0 
 Jan. 25, 2019. 
- Changed class StateListener to a mixin
- addState() in Controller and Listener adding any number of Views
- abstract class StateViewMVC<T extends StatefulWidget> extends StateMVC<T>
- class ViewMVC extends _StateObserver with _ControllerListing 
- void didChangeDependencies() will not refresh() on first build
- Removed from Controllers the getters: widget, context, mounted
- stateView getter is deprecated. Replaced by stateMVC. Removed stateMVC setter.
- Removed controller setter in class ViewMVC
- if (con is AppConMVC) //bool addBeforeListener(StateListener listener)

## 2.0.2 
 Jan. 19, 2019. 
- void addState(StateMVC state) {

## 2.0.1 
 Jan. 16, 2019. 
- AppMVC({this.con, Key key}) : super(key: key);

## 2.0.0 
 Jan. 16, 2019.   
- ControllerMVC(State state)
- class _StateView with StateListener
- _StateView() : _oldOnError = _recOnError() {
- abstract class StateMVC<T extends StatefulWidget> extends State<StatefulWidget>
- remove setter, controller
- _StateListener.disposeStateEventList() use clear();
- Removed StatefulWidgetMVC
- Removed StatedWidget
- abstract class AppMVC extends StatefulWidget {
- Removed StatelessWidgetMVC

## 1.3.6 
 Jan. 12, 2019.   
- StateListener to replace StateEvents. addState() disposedState()

## 1.3.5 
 Jan. 11, 2019.   
- remove StateListener

## 1.3.4 
 Jan. 11, 2019.   
- StateListener as a mixin for StateEvents

## 1.3.3 
 Jan. 01, 2019.   
- Removed @protected from ViewMVC.build()  Private _ControllerListing._con(String keyId)


## 1.3.2 
 Dec. 28, 2018.   
- if(mounted) in refresh()

## 1.3.1 
 Dec. 10, 2018.   
- sdk: ">=2.0.0 <5.0.0"

## 1.3.0 
 Dec. 03, 2018.   
- Updated README.md

## 1.3.0 
 Nov. 18, 2018.   
- add some further examples under test folder

## 1.2.4 
 Nov. 17, 2018.   
- fix on StateEvents assign on keyId

## 1.2.3 
 Nov. 13, 2018.   
- test for TestWidgetsFlutterBinding

## 1.2.2 
 Nov. 02, 2018.   
- fix on StatedWidget

## 1.2.1 
 Nov. 02, 2018.   
- fix on StateViewMVC

## 1.2.0 
 Oct. 29, 2018.   
- enhance AppMVC

## 1.1.1 
 Oct. 27, 2018.   
- StatefulWidgetMVC deemed deprecated

## 1.1.0 
 Oct. 25, 2018.   
- keyId in StateEvents

## 1.0.0 
 Oct. 24, 2018.   
- Official Production Release

## 0.0.14 
 Oct. 24, 2018.   
- fix on StateViewMVC & AppMVC & @protected

## 0.0.13 
 Oct. 23, 2018.   
- fix on _ControllerListing

## 0.0.12 
 Oct. 23, 2018.   
- class ViewMVC with _ControllerListing

## 0.0.11 
 Oct. 23, 2018.   
- class StateMVC with _ControllerListing, _StateEventList

## 0.0.10 
 Oct. 22, 2018.   
- include travis.yml

## 0.0.9 
 Oct. 21, 2018.   
- fix on ViewMVC & StateViewMVC

## 0.0.8 
 Oct. 20, 2018.   
- Updated the README.md

## 0.0.7 
 Oct. 19, 2018.   
- Provide example/main.dart

## 0.0.6 
 Oct. 18, 2018.   
- fix on StateMVC.con()

## 0.0.5 
 Oct. 18, 2018.   
- fix on StatedWidget

## 0.0.4 
 Oct. 18, 2018.   
- fix on StateMVC.add()

## 0.0.3 
 Oct. 18, 2018.  
- fix on AppMVC and StateEvents

## 0.0.1 
 Oct. 13, 2018. 
- Initial Release