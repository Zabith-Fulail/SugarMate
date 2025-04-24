import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension AppSpacing on num {
  Widget get verticalSpace => SizedBox(height: h);

  Widget get horizontalSpace => SizedBox(width: w);
}
