
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final double? horMargin;
  final double? verMargin;

  ShimmerWidget.rectangular(
      {super.key,
      required this.width,
      required this.height,
      this.horMargin,
      this.verMargin})
      : shapeBorder =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0));

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.horMargin,
    this.verMargin,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: verMargin ?? 10.0, horizontal: horMargin ?? 0.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: shapeBorder,
        ),
      ),
    );
  }
}
