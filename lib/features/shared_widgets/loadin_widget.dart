import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadinWidget extends StatelessWidget {
  const LoadinWidget({super.key,  this.size,this.color});
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: size?.r ?? 10.r,color:color??Colors.black ,);
  }
}