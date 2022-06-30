///
///
///

import 'package:flutter/material.dart';

///
mixin InheritedStateMixin on State<StatefulWidget> {
  /// Build the 'child' Widget passed to the InheritedWidget.
  Widget buildChild(BuildContext context);

  /// Provide access to the 'InheritedWidget' StatefulWidget
  InheritedStatefulWidget get inheritedStatefulWidget =>
      _inheritedStatefulWidget;

  /// The Inherited StatefulWidget that contains the InheritedWidget.
  late InheritedStatefulWidget _inheritedStatefulWidget;

  /// Traditionally called in the initState() function
  void initInheritedState<T extends InheritedWidget>(
      T Function(Widget child) inheritedWidgetBuilder) {
    // Create the StatefulWidget to contain the InheritedWidget
    _inheritedStatefulWidget = InheritedStatefulWidget<T>(
        inheritedWidgetBuilder: inheritedWidgetBuilder,
        child: _BuildBuilder(builder: buildChild));
  }

  /// Link a widget to a InheritedWidget of type U
  bool widgetInherited(BuildContext? context) =>
      _inheritedStatefulWidget.widgetInherited(context);

  ///
  InheritedElement? inheritedElement(BuildContext? context) =>
      _inheritedStatefulWidget.inheritedElement(context);

  /// A flag to prevent infinite loops.
  bool _buildInherited = false;

  /// Don't rebuild this State object but the State object containing the InheritedWidget.
  /// Rebuild all the dependencies of the _InheritedWidget widget.
  @override
  void setState(VoidCallback fn) {
    _buildInherited = true;
    _inheritedStatefulWidget.setState(fn);
    _buildInherited = false;
  }

  /// Provide a means to rebuild this State object anyway.
  void setSuperState(VoidCallback fn) => super.setState(fn);

  /// Implement this function instead of the build() function
  /// to utilize a built-in FutureBuilder Widget and InheritedWidget.
  ///
  /// Introduce an Inherited widget and simply passing through a 'child' widget.
  /// When the Inherited Widget is rebuilt only this build() function is called.
  /// i.e. The rest of the widget tree, widget.child, is left alone.
  @override
  Widget build(BuildContext context) => _inheritedStatefulWidget;
}

/// Passes along a InheritedWidget to its State object.
class InheritedStatefulWidget<U extends InheritedWidget>
    extends StatefulWidget {
  /// No key so the state object is not rebuilt because it can't be.
  InheritedStatefulWidget({
    Key? key,
    required this.inheritedWidgetBuilder,
    required this.child,
  })  : state = _InheritedState(),
        super(key: key);

  /// Supply a child Widget to the returning InheritedWidget's child parameter.
  final U Function(Widget child) inheritedWidgetBuilder;

  /// The 'child' Widget eventually passed to the InheritedWidget.
  final Widget child;

  /// This StatefulWidget's State object.
  final _InheritedState state;

  @override
  //ignore: no_logic_in_create_state
  _InheritedState createState() => state;

  /// Link a widget to a InheritedWidget of type U
  bool widgetInherited(BuildContext? context) {
    bool dependOn = context != null;
    if (dependOn) {
      final inheritedWidget = context.dependOnInheritedWidgetOfExactType<U>();
      dependOn = inheritedWidget != null;
    }
    return dependOn;
  }

  ///
  InheritedElement? inheritedElement(BuildContext? context) {
    InheritedElement? element;
    if (context != null) {
      element = context.getElementForInheritedWidgetOfExactType<U>();
    }
    return element;
  }

  /// The 'child' widget passed to the InheritedWidget
  Widget get inheritedChildWidget => state.child!;

  /// set the child widget.
  set inheritedChildWidget(Widget? child) => state.child = child;

  /// Call its State object's setState() function
  void setState(VoidCallback fn) => state._setState(fn);

  /// Rebuild the InheritedWidget and its dependencies.
  void buildInherited() => setState(() {});

  /// In harmony with Flutter's own API
  void notifyClients() => setState(() {});

  /// Inline with 'older' frameworks
  void refresh() => setState(() {});
}

class _InheritedState extends State<InheritedStatefulWidget> {
  @override
  void initState() {
    super.initState();
    _widget = widget;
  }

  late InheritedStatefulWidget _widget;

  /// Supply an alternate 'child' Widget
  Widget? child;

  /// Called by the StatefulWidget
  void _setState(VoidCallback fn) => setState(fn);

  @override
  Widget build(BuildContext context) =>
      _widget.inheritedWidgetBuilder(child ??= _widget.child);
}

/// Creates a Widget but supplying contents to its build() function
class _BuildBuilder extends StatelessWidget {
  const _BuildBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    late Widget widget;
    try {
      widget = builder(context);
    } catch (e) {
      //
      final errorDetails = FlutterErrorDetails(
        exception: e,
        stack: e is Error ? e.stackTrace : null,
        library: 'mvc_pattern.dart',
        context:
            ErrorDescription("While building 'child' for InheritedWidget."),
      );

      FlutterError.reportError(errorDetails);

      widget = ErrorWidget.builder(errorDetails);
    }
    return widget;
  }
}
