import 'package:aycel/features/home/data/models/category_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/router/app_routes.dart';
import '../../shared_widgets/custom_text.dart';
import 'category_item.dart';

class HomeCategories extends StatelessWidget {
  HomeCategories({super.key, required this.categories});
  final List<CategoryModel> categories;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "categories".tr(),
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        Gap(20.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => Gap(16.w),
            itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryItem(
              isSvg: false,
              title: category.name,
              image: category.image,
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoutes.cat_product);
              },
            );
            },
          ),
        ),
      ],
    );
  }
}