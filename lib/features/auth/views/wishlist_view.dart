import 'package:aycel/features/auth/data/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:aycel/features/auth/data/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/router/app_routes.dart';
import '../../home/widgets/product_card.dart';
import '../../product/data/cubit/favorite_cubit.dart';
import '../../shared_widgets/custom_text.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AppAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: "wishlist_item".tr(),
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: RefreshIndicator(
          onRefresh:()=>context.read<WishlistCubit>().refresh(),
          child:BlocBuilder<WishlistCubit, WishlistState>(
        builder: (BuildContext context, WishlistState state) {
          if (state is WishListLoading) {
            return const Center(
              child: LoadinWidget(color: Colors.black,size: 20,),
            );
          }

          if (state is WishListError) {
            return Center(
              child: CustomText(
                text: state.message,
                size: 18,
                color: Colors.red,
              ),
            );
          }

          // ✅ باقي الحالات جوة الـ SingleChildScrollView
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (BuildContext context, WishlistState state) {
                if (state is WishListLoaded) {
                  final products = context.read<WishlistCubit>().products;

                  // ✅ الـ empty state برضو في نص الصفحة
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 80.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start adding items to your wishlist',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // ✅ الـ GridView
                  return GridView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.63,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index]!;
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed(AppRoutes.product, extra: product);
                        },
                        child: ProductCard(
                          price:  product.finalPrice.toString() ?? "",
                          oldPrice:product.price.toString() ?? "",                          id: product.id,
                          image: product.image ?? "",
                          name: product.name ?? "",
                          hasDiscount: product.hasDiscount,
                          onTab: () {
                            GoRouter.of(context).pushNamed(AppRoutes.product, extra: product.id);
                          },
                          onFavTab: () {
                            context.read<FavoriteCubit>().toggle(product.id);
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
        )
        ),
      ),
    );
  }
}
