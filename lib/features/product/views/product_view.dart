import 'package:aycel/core/router/app_routes.dart';
import 'package:aycel/features/product/data/cubit/cart_product_cubit.dart';
import 'package:aycel/features/product/data/cubit/cart_product_state.dart';
import 'package:aycel/features/product/widgets/color_widget.dart';
import 'package:aycel/features/product/widgets/images_widget.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';
import '../data/cubit/product_cubit.dart';
import '../data/cubit/product_state.dart';
import '../data/product_detail_model.dart';
import '../widgets/size_widget.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

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
        onRefresh: context.read<ProductCubit>().refresh,
        color: AppColors.primary,
        edgeOffset: 5,

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded) {
                  return CustomText(
                    height: 2.h,
                    textAlign: TextAlign.center,
                    text: state.product.name,
                    maxLines: 2,
                    size: 13.sp,
                    fontWeight: FontWeight.bold,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          backgroundColor: Colors.grey.withValues(alpha: 0.80),
          body: BlocBuilder<ProductCubit, ProductState>(
            builder: (BuildContext context, ProductState state) {
              if (state is ProductLoading) {
                return const Center(child: LoadinWidget(size: 20));
              }
              if (state is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: state.message,
                        color: Colors.red.shade900,
                        maxLines: 5,
                        size: 19,
                      ),
                    ],
                  ),
                );
              }
              if (state is ProductLoaded) {
                final product = state.product;
                final cubit = context.read<ProductCubit>();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ImagesWidget(
                        image: product.images[cubit.selectedImage].image,
                        productId: product.id,
                      ),
                      Gap(16.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 120.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.images.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final selected = cubit.selectedImage == index;
                                  final image = product.images[index];
                                  final discountPercentage = (((
                                      double.parse(product.price.toString()) -
                                          double.parse(product.finalPrice.toString())
                                  ) /
                                      double.parse(product.price.toString())) * 100).round();
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<ProductCubit>().selectImage(
                                        index,
                                      );
                                    },
                                    child: Container(
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: CachedNetworkImage(
                                        httpHeaders: {"Connection": "close"},
                                        imageUrl: product.images[index].image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Center(child: LoadinWidget()),
                                        errorWidget: (context, url, error) {
                                          return const Icon(Icons.broken_image);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Gap(16.h),
                            Container(
                              width: double.infinity,
                              // decoration: BoxDecoration(color: Colors.white70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: product.name,
                                    size: 25,
                                    maxLines: 5,
                                    fontWeight: FontWeight.bold,
                                  ),

                                  Gap(10.h),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: "${product.finalPrice} ₪",
                                        size: 25,
                                        fontWeight: FontWeight.bold,
                                      ),

                                      if (product.price != product.finalPrice) ...[
                                        Gap(10.w),

                                        CustomText(
                                          text: "${product.price} ₪",
                                          size: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          hasLine: true,
                                        ),

                                        Gap(10.w),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 9.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: CustomText(
                                            text:
                                            "discount".tr(args: [
                                              (((double.parse(product.price.toString()) -
                                                  double.parse(product.finalPrice.toString())) /
                                                  double.parse(product.price.toString())) *
                                                  100)
                                                  .round()
                                                  .toString(),
                                            ]),
                                            color: Colors.white,
                                            size: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Gap(16.h),
                                  Divider(),
                                  Gap(16.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "choose_color_size".tr(),
                                        fontWeight: FontWeight.bold,
                                        size: 16,
                                      ),
                                      CustomText(
                                        text:
                                            "${cubit.availableStock} ${"avilable_qty".tr()}",
                                        fontWeight: FontWeight.bold,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  Gap(16.h),
                                  if (product.sizes.isNotEmpty)
                                    SizeWidget(
                                      sizes: product.sizes,
                                      selectedSize: cubit.selectedSize,
                                      onSelected: (index) {
                                        context.read<ProductCubit>().selectSize(
                                          index,
                                        );
                                      },
                                    ),
                                  if (product.colors.isNotEmpty)
                                    ColorWidget(
                                      colors: product.colors,
                                      selectedColor: cubit.selectedColor,
                                      onSelected: (index) {
                                        context
                                            .read<ProductCubit>()
                                            .selectColor(index);
                                      },
                                    ),
                                  Gap(16.h),
                                  Divider(),
                                  Gap(16.h),
                                  CustomText(
                                    text: "descriptions".tr(),
                                    fontWeight: FontWeight.bold,
                                    size: 16,
                                  ),
                                  Gap(16.h),
                                  CustomText(
                                    text: product.shortDescription,
                                    fontWeight: FontWeight.normal,
                                    maxLines: 100,
                                    color: Colors.black87,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                            Gap(100.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CustomText(text: "Erorr ", color: Colors.red)],
                  ),
                );
              }
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  final cubit = context.read<ProductCubit>();
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.increaseQuantity();
                              },
                              icon: const Icon(Icons.add),
                            ),
                            CustomText(
                              text: "${context.read<ProductCubit>().quantity}",
                              size: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            IconButton(
                              onPressed: () {
                                if (context.read<ProductCubit>().quantity > 1) {
                                  cubit.decreaseQuantity();
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),

                      Gap(12.w),

                      BlocBuilder<ProductCubit,ProductState>(
                        builder: (BuildContext context, ProductState state) {
                         return  Expanded(
                            child: SizedBox(
                              height: 52.h,
                              child: BlocConsumer<CartProductCubit, CartProductState>(
                                listener: (BuildContext context, CartProductState state) {
                                  if (state is CartAdded) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(
                                        backgroundColor: Colors.green,

                                        content: Center(
                                          child: CustomText(
                                            text: "added_successfully".tr(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is CartError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (BuildContext context, CartProductState state) {
                                  final product = context.read<ProductCubit>().product;


                                  return ElevatedButton.icon(
                                    onPressed: state is CartAdding ? null :(){
                                      context.read<CartProductCubit>().addToCart(
                                        productId: product!.id,
                                        colorId: cubit.selectedColorId,
                                        sizeId: cubit.selectedSizeId,
                                        quantity: cubit.quantity,
                                      );
                                      GoRouter.of(context).pushNamed(AppRoutes.cart);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14.r),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "add_to_cart".tr(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
