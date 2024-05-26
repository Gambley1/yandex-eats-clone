// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeConfig {
  factory HomeConfig() => _internal ?? HomeConfig._();

  HomeConfig._();

  static HomeConfig? _internal = HomeConfig._();

  late BuildContext _navigationContext;
  StatefulNavigationShellState? get _navigationShellState =>
      StatefulNavigationShell.maybeOf(_navigationContext);

  void init(BuildContext context) {
    _navigationContext = context;
  }

  void goBranch(int index) => _navigationShellState?.goBranch(index);

  void dispose() {
    _internal = null;
  }
}
