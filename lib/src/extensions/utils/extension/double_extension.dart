import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension DoubleExtension on double {
  Widget get width => SizedBox(width: w);

  Widget get height => SizedBox(height: h);
}
