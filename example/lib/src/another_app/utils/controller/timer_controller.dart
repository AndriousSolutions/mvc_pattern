// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
///
///
///

import 'dart:async';

import 'package:example/src/view.dart';

///
class TimerController extends ControllerMVC {
  /// Either create a Timer now or start the Timer later.
  TimerController({
    this.periodic,
    this.days,
    this.hours,
    this.minutes,
    this.seconds,
    this.milliseconds,
    this.microseconds,
    this.duration,
    this.callback,
    StateMVC? state,
  }) : super(state) {
    // Record the callback function.
    _callback = callback;
  }
  //
  Duration? _duration;

  ///
  bool? periodic;

  ///
  int? days;

  ///
  int? hours;

  ///
  int? minutes;

  ///
  int? seconds;

  ///
  int? milliseconds;

  ///
  int? microseconds;

  ///
  Duration? duration;

  /// The callback function that runs after the prescribed duration.
  final void Function()? callback;

  void Function()? _callback;

  ///
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the Timer if a duration is provided.
    startTimer();
  }

  @override
  void deactivate() {
    cancelTimer();
    super.deactivate();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    cancelTimer();
    return super.didPopRoute();
  }

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //
    if (state == AppLifecycleState.resumed) {
      /// Create the Timer again.
      _createTimer();
    } else if (state == AppLifecycleState.paused) {
      /// Passing these possible values:
      /// AppLifecycleState.paused (may enter the suspending state at any time)
      /// AppLifecycleState.inactive (may be paused at any time)
      /// AppLifecycleState.suspending (Android only)
      cancelTimer();
    }
  }

  /// Assign the callback function
  /// Returns false if already assigned.
  bool callbackTimer(void Function()? callback) {
    final set = _callback == null && callback != null;
    if (set) {
      _callback = callback;
    }
    return set;
  }

  /// Cancel the timer
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Run the callback as soon as possible.
  /// Returns true if Timer callback will fire.
  bool runTimer({
    bool? periodic,
    int? days,
    int? hours,
    int? minutes,
    int? seconds,
    int? milliseconds,
    int? microseconds,
    Duration? duration,
    void Function()? callback,
  }) {
    // Supply the callback routine if any.
    callbackTimer(callback);

    final run = _callback != null;

    if (run) {
      // If no duration is provided and a Timer created, run callback right away.
      if (!startTimer(
        periodic: periodic,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
        duration: duration,
      )) {
        Timer.run(_callback!);
      }
    }
    return run;
  }

  /// Supply the duration to start the Timer.
  bool startTimer({
    bool? periodic,
    int? days,
    int? hours,
    int? minutes,
    int? seconds,
    int? milliseconds,
    int? microseconds,
    Duration? duration,
    void Function()? callback,
  }) {
    // If supplied a callback and yet not successfully assigned.
    if (callback != null && !callbackTimer(callback)) {
      return false;
    }
    // Supply appropriate parameters
    this.periodic = periodic ?? this.periodic;
    this.days = days ?? this.days;
    this.hours = hours ?? this.hours;
    this.minutes = minutes ?? this.minutes;
    this.seconds = seconds ?? this.seconds;
    this.milliseconds = milliseconds ?? this.milliseconds;
    this.microseconds = microseconds ?? this.microseconds;
    this.duration = duration ?? this.duration;
    // If a duration is provided, a Timer is created and started.
    return _createTimer();
  }

  /// Create or recreate a Timer.
  bool _createTimer() {
    //
    _timer?.cancel();

    _timer = null;

    // Determine the Duration
    _duration = duration ??
        Duration(
          days: days ?? 0,
          hours: hours ?? 0,
          minutes: minutes ?? 0,
          seconds: seconds ?? 0,
          milliseconds: milliseconds ?? 0,
          microseconds: microseconds ?? 0,
        );

    // There's go to be a Duration create a Timer.
    if (_callback != null && _duration!.inMicroseconds > 0) {
      // Repeat the duration again and again?
      if (periodic ?? false) {
        //
        _timer = Timer.periodic(
          _duration!,
          (timer) => _runCallback(),
        );
      } else {
        //
        _timer = Timer(
          _duration!,
          _runCallback,
        );
      }
    }
    return _timer != null;
  }

  void _runCallback() {
    try {
      _callback!();
    } catch (e) {
      cancelTimer();
      _error = e;
      _running = false;
    }
  }

  /// Indicate if the Timer is successfully running.
  bool get running => _running;
  bool _running = true;

  /// Supplies the occurred error if any.
  Object? get error => _error;
  Object? _error;
}
