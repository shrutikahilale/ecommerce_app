import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: non_constant_identifier_names
Widget CustomProgressIndicator() {
  return Center(
      child: LoadingAnimationWidget.dotsTriangle(
    color: Colors.deepOrange,
    size: 200,
  ));
}
