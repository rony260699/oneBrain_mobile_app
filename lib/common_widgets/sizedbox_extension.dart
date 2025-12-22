import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
} 