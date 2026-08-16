import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constant/app_assets.dart';
import '../../../core/router/app_routes.dart';
import '../../home/data/cubit/home_cubit.dart';
import '../../home/widgets/product_card.dart';
import '../../product/data/cubit/favorite_cubit.dart';
import '../../shared_widgets/custom_text.dart';
import '../../home/widgets/category_item.dart';
import '../../shared_widgets/loadin_widget.dart';
import '../data/cubit/cat_cubit.dart';
import '../data/cubit/cat_state.dart';

class CategoriesProductsView extends StatelessWidget {
  const CategoriesProductsView({super.key});

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
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.h,
          centerTitle: true,
          title: CustomText(text: "categories".tr(), size: 22),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.grey.withValues(alpha: 0.92),
        body: BlocBuilder<CatCubit, CatState>(
          builder: (BuildContext context, CatState state) {
            if (state is CatsLoading) {
              return const Center(child: LoadinWidget(size: 20,));
            }
            if (state is CatsError) {
              return Center(child: Text(state.message));
            }
            if (state is CatsLoaded) {
              final categories = state.cats;
              final products = state.products;
              final selectedCategoryId = state.selectedCategoryId;

              final isLoadingProducts = state.isLoadingProducts;

              final selectedCategory = categories.firstWhere(
                    (cat) => cat.id == selectedCategoryId,
                orElse: () => categories.first,
              );


              return RefreshIndicator(
                onRefresh:  context.read<CatCubit>().refresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16.h),
                        CustomText(
                          text: "all_categories".tr(),
                          fontWeight: FontWeight.bold,
                          size: 22.sp,
                        ),
                        Gap(16.h),
                        SizedBox(
                          height: 110.h,
                          child:  ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, __) => Gap(16.w),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = category.id == selectedCategoryId;
                              return CategoryItem(
                                isSvg: false,
                                title: category.name,
                                image: category.image,
                                isSelected: isSelected,
                                onTap: () {
                                  context.read<CatCubit>().changeCategory(category.id);
                                },
                              );
                            },
                          ),
                        ),
                        Gap(24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "products".tr() + " "+ (selectedCategory?.name ?? ''),
                              fontWeight: FontWeight.bold,
                              size: 18.sp,
                            ),
                          ],
                        ),
                        Gap(16.h),

                        isLoadingProducts
                            ? SizedBox(
                          height: 200.h,
                          child: const Center(
                            child: LoadinWidget(size: 20,),
                          ),
                        )
                            :
                        products.isEmpty
                            ? SizedBox(
                          height: 200.h,
                          child: Center(
                            child: CustomText(
                              text: "no_products".tr(),
                              size: 20.sp,
                              color: Colors.red.shade900,
                            ),
                          ),
                        )
                            : GridView.builder(
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
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  AppRoutes.product,
                                  extra: product,
                                );
                              },
                              child: ProductCard(
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
                            }, hasDiscount: product.hasDiscount,
                            ),
                            );
                          },
                        ),
                        Gap(100.h),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: LoadinWidget());
          },
        ),
      ),
    );
  }
}