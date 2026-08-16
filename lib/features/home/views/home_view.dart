import 'package:aycel/core/constant/app_colors.dart';
import 'package:aycel/features/home/data/cubit/home_cubit.dart';
import 'package:aycel/features/home/data/cubit/home_state.dart';
import 'package:aycel/features/home/data/models/category_model.dart';
import 'package:aycel/features/home/data/models/slider_model.dart';
import 'package:aycel/features/home/widgets/item_sketlon.dart';
import 'package:aycel/features/shared_widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_seting.dart';
import '../../../core/router/app_routes.dart';
import '../../product/data/cubit/favorite_cubit.dart';
import '../data/models/home_product_model.dart';
import '../widgets/home_categories.dart';
import '../widgets/product_card.dart';
import '../widgets/slider_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: RefreshIndicator(
        color: AppColors.secondary,
        displacement: 100.h,
        onRefresh: () => context.read<HomeCubit>().refresh(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70.h,
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Icon(CupertinoIcons.search),
              ),
            ],
            leading: SizedBox.shrink(),
            title: CustomText(
              text: AppSetting.appName,
              size: 30,
              fontWeight: FontWeight.normal,
              color: AppColors.secondary,
            ),
          ),
          backgroundColor: Colors.grey.withValues(alpha: 0.92),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeError) {
                print(state.message);
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: state.message,
                        color: Colors.red,
                        size: 12,
                        maxLines: 5,
                      ),
                      Gap(16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeCubit>().refresh();
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              List<SliderModel> sliders = [];
              List<CategoryModel> cats = [];
              List<HomeProductModel> products = [];

              if (state is HomeLoaded) {
                sliders = state.home.sliders!;
                cats = state.home.categories!;
                products = state.home.featuredProducts!;
              }
              return Skeletonizer(
                enabled: state is HomeLoading,
                effect: ShimmerEffect(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  duration: Duration(milliseconds: 1200),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is HomeLoading)

                        Column(
                          children: [
                            Gap(10.h),
                            Container(
                              height: 200.h,
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                          ],
                        )
                      else
                        SliderWidget(
                          sliders: sliders,
                        ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(16.h),

                            if (state is HomeLoading)
                              SizedBox(
                                height: 100.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  separatorBuilder: (_, __) => Gap(12.w),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 60.w,
                                          height: 60.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Gap(8.h),
                                        Container(
                                          width: 50.w,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            else
                              HomeCategories(categories: cats),

                            Gap(16.h),

                            if (state is HomeLoading)
                              Container(
                                width: 120.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              )
                            else
                              CustomText(
                                text: "new_arrived".tr(),
                                fontWeight: FontWeight.bold,
                                size: 18.sp,
                              ),

                            Gap(16.h),

                            GridView.builder(
                              itemCount: state is HomeLoaded ? products.length : 8,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: .64,
                              ),
                              itemBuilder: (context, index) {
                                if (state is HomeLoaded) {
                                  final product = products[index];
                                  return ProductCard(
                                    hasDiscount: product.hasDiscount,
                                    price:  product.finalPrice.toString() ?? "",
                                    oldPrice:product.price.toString() ?? "",
                                    id:  product.id,
                                    image: product.image ?? "",
                                    name: product.name ?? "",

                                    onTab: () {
                                      GoRouter.of(context).pushNamed(
                                        AppRoutes.product,
                                        extra: product.id,
                                      );
                                    }, onFavTab: () {
                                    context.read<FavoriteCubit>().toggle(product.id);
                                  },
                                  );
                                }
                                return ItemSketlon();
                              },
                            ),

                            Gap(100.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}