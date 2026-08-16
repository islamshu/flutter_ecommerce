import 'package:aycel/features/cart/data/cubit/cart_cubit.dart';
import 'package:aycel/features/cart/data/cubit/cart_state.dart';
import 'package:aycel/features/cart/widgets/cart_product_widget.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../shared_widgets/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int quantity = 1;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AppAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const SizedBox.shrink(),
          title: CustomText(
            text: "cart".tr(),
            size: 30,
            fontWeight: FontWeight.normal,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: Colors.grey.withValues(alpha: 0.92),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (BuildContext context, CartState state) {

            if(state is CartLoading){
              return Center(child: LoadinWidget(size: 15,),);
            }
            if (state is CartError) {
              return Center(
                child: CustomText(text: state.message, color: Colors.red,),);
            }
            if (state is CartLoaded) {
              return RefreshIndicator(
                onRefresh: context.read<CartCubit>().getCartData,
                child: CustomScrollView(
                  slivers: <Widget>[
                    // Sliver for the header content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(16.h),
                            CustomText(
                              text: "حقيبة التسوق",
                              size: 30,
                              fontWeight: FontWeight.normal,
                              color: AppColors.primary,
                            ),
                            Gap(8.h),
                            CustomText(
                              text: "لديك ${state.carts.items.length}  منتجات في سلتك",
                              size: 18,
                              fontWeight: FontWeight.normal,
                              color: AppColors.primary,
                            ),
                            Gap(16.h),
                          ],
                        ),
                      ),
                    ),
                    if (state.carts.items.isEmpty)
                       SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: Center(
                            child: CustomText(text: "Cart is Empty".tr()),
                          ),
                        ),
                      )
                    else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context,
                          int index,) {
                        final product = state.carts.items[index].product;
                        final cart = state.carts.items[index];
                        return CartProductWidget(
                          item: cart,
                          onDelete: () {
                            context.read<CartCubit>().remove(cart.id);
                          },
                        );
                      }, childCount: state.carts.items.length ),
                    ),
                    SliverToBoxAdapter(child: Gap(260.h)),
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
        bottomSheet: Container(
          height: 250.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "total".tr(),
                      size: 18,
                      color: Colors.grey,
                    ),
                    BlocBuilder<CartCubit,CartState>(
                      builder: (BuildContext context, CartState state) {
                        if(state is CartLoading){
                          return Center(child: LoadinWidget(),);
                        }
                        if(state is CartLoaded){
                          return
                            CustomText(
                              text: "${context.read<CartCubit>().cart?.subtotal} ₪",
                              size: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            );
                        }
                        return SizedBox();

                      },

                    ),
                  ],
                ),
                Gap(18.h),
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(AppRoutes.checkout);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    icon: Icon(Icons.lock, color: Colors.white),
                    label: Text(
                      "checkout".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),),
    );
  }
}
