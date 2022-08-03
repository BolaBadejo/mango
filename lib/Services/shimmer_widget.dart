import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({Key? key, required this.width, required this.height}) : shapeBorder = const RoundedRectangleBorder(), margin = const EdgeInsets.all(0);
  const ShimmerWidget.rectangularCircular({Key? key, required this.width, required this.height}) :  margin = const EdgeInsets.all(0), shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
  const ShimmerWidget.rectangularCircularMargin({Key? key, required this.width, required this.height, required this.margin}) :  shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
  const ShimmerWidget.circular({Key? key, required this.width, required this.height, this.shapeBorder = const CircleBorder()}) :  margin = const EdgeInsets.all(0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        highlightColor: Colors.grey[200]!,
    baseColor: Colors.grey[100]!,
    child: Container(
      margin: margin,
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: shapeBorder,
        color: Colors.grey,
      ),

    ));
  }
}
