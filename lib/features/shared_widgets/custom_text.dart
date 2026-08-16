import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constant/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.size,
    this.fontFamily,
    this.maxLines,
    this.textAlign,
    this.height,
    this.hasLine,
    this.overflow,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? size;
  final int? maxLines;
  final String? fontFamily;
  final TextAlign? textAlign;
  final double? height;
  final bool? hasLine; // true = lineThrough, false = none
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: GoogleFonts.cairo(
        color: color ?? AppColors.primary,
        fontSize: size?.sp ?? 18.sp,
        fontWeight: fontWeight,
        height: height,
        decoration: hasLine == true ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }
}