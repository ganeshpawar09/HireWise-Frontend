import 'package:flutter/material.dart';

class SkelatonWidget extends StatelessWidget {
  final double width;
  final double height;
  const SkelatonWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade300,
      ),
    );
  }
}
