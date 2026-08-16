import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';
import '../data/product_detail_model.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  final List<SizeModel> sizes;
  final int selectedSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "size".tr(),
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        Gap(8.h),
        SizedBox(
          height: 55.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sizes.length,
            itemBuilder: (context, index) {
              final isSelected = selectedSize == index;

              return Padding(
                padding: EdgeInsetsDirectional.only(end: 10.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 65.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.selected
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.selected
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        text: sizes[index].name,
                        size: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
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