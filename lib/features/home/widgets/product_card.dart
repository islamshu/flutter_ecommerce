import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../product/data/cubit/favorite_cubit.dart';
import '../../product/data/cubit/favorite_state.dart';
import '../../shared_widgets/custom_text.dart';
import '../../shared_widgets/loadin_widget.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.onTab,
    required this.onFavTab,
    required this.id,
    required this.hasDiscount,
    this.oldPrice,
  });

  final int id;
  final String image;
  final String name;
  final String price;
  final String? oldPrice;
  final bool hasDiscount;
  final Function() onTab;
  final Function() onFavTab;

  double get discountPercentage {
    if (!hasDiscount || oldPrice == null) return 0;

    final oldPriceValue = double.tryParse(oldPrice!) ?? 0;
    final currentPriceValue = double.tryParse(price) ?? 0;

    if (oldPriceValue <= 0 || currentPriceValue >= oldPriceValue) {
      return 0;
    }

    return ((oldPriceValue - currentPriceValue) / oldPriceValue) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 164.h,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(
                        child: LoadinWidget(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.broken_image,
                      );
                    },
                  ),
                ),

                BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, state) {
                    final cubit = context.read<FavoriteCubit>();

                    final fav = cubit.isFavorite(id);

                    final loading =
                        state is FavoriteLoading &&
                            state.productId == id;

                    return Positioned(
                      top: 20.h,
                      left: 10.w,
                      child: GestureDetector(
                        onTap: loading
                            ? null
                            : () => cubit.toggle(id),
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: loading
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                              CupertinoActivityIndicator(),
                            )
                                : Icon(
                              fav
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: fav
                                  ? Colors.red
                                  : Colors.black87,
                              size: fav ? 28.sp : 20.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                if (hasDiscount &&
                    oldPrice != null &&
                    discountPercentage > 0)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        text:
                        "discount".tr(
                          args: [discountPercentage.round().toString()],
                        ),
                        color: Colors.white,
                        size: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    maxLines: 2,
                    size: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  Gap(8.h),

                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "$price ₪",
                        size: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),

                      if (hasDiscount &&
                          oldPrice != null &&
                          discountPercentage > 0) ...[
                        Gap(8.w),
                        CustomText(
                          text: "$oldPrice ₪",
                          size: 13.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          hasLine: true,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}