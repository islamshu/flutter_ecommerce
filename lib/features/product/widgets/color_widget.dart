import 'package:aycel/features/product/data/product_detail_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelected,
  });

  final List<ColorModel> colors;
  final int selectedColor;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16.h),
        CustomText(text: "color".tr(), fontWeight: FontWeight.bold, size: 18),
        Gap(8.h),
        SizedBox(
          height: 55.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final isSelected = selectedColor == index;
              final  color = colors[index];
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 4.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => onSelected(index),
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.color,
                      border: isSelected
                          ? Border.all(color: AppColors.selected, width: 5)
                          : null,
                    ),
                    child: isSelected ?  Icon(Icons.check,size: 20.sp,color: AppColors.selected,) : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
