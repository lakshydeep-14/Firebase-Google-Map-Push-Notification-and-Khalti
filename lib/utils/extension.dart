export './colors.dart';
export './constants.dart';
export './images.dart';
export 'package:get/get.dart';
export './global_widgets.dart';
export 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  double get deviceHeight => MediaQuery.of(this).size.height;
  double get deviceWidth => MediaQuery.of(this).size.width;
}
