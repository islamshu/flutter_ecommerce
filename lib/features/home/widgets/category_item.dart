import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';
import '../../shared_widgets/loadin_widget.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isSvg;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.title,
    required this.image,
    this.isSvg = false,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              border: isSelected
                  ? Border.all(color: AppColors.selected, width: 3.w)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              height: 120.h,
              width: 120.w,


              child:ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12.w),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: LoadinWidget()),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error);
                  },
                ),
              )
            ),
          ),
          Gap(8.h),
          CustomText(
            text: title,
            size: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
