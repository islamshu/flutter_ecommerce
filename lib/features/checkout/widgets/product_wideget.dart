import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';

class ProductWideget extends StatelessWidget {
   ProductWideget({super.key, required this.image, required this.name, this.color, this.size, required this.price, required this.qnt});
  final String image;
  final String name;
  final String? color;
  final String? size;
  final String price;
  final String qnt;

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding:  EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: image, width: 100.w, height: 100.h),
                SizedBox(
                  width: 150.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        maxLines: 4,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      CustomText(
                        text: "qty".tr() + ":" + qnt!,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      color != null ?
                      CustomText(
                        text: "color".tr() + ":" + color!,
                        size: 14,
                        color: AppColors.primary,
                      ):SizedBox(),
                      size != null ?
                      CustomText(
                        text: "size".tr() + ":" + size!,
                        size: 14,
                        color: AppColors.primary,
                      ):SizedBox(),
                    ],
                  ),
                ),
                Spacer(),

                CustomText(text: "${price} ₪", size: 18, color: AppColors.primary),
              ],
            ),
            Divider(thickness: 0.5,),
          ],
        ),

    );
  }
}
