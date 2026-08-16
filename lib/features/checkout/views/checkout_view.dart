import 'package:aycel/core/constant/app_colors.dart';
import 'package:aycel/core/router/app_routes.dart';
import 'package:aycel/features/checkout/data/cubit/checkout_cubit.dart';
import 'package:aycel/features/checkout/data/cubit/checkout_state.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../auth/widgets/text_edit.dart';
import '../../shared_widgets/custom_text.dart';
import '../data/city_model.dart';
import '../widgets/product_wideget.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
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

        appBar: AppBar(centerTitle: true,
            backgroundColor: Colors.white,
            title: Text('checkout'.tr()),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(16.h),
                  CustomText(
                    text: "ملخص الطلب".tr(),
                    size: 20,
                    color: AppColors.primary,
                  ),
                  Gap(16.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<CheckoutCubit,CheckoutState>(
                            builder: (BuildContext context, CheckoutState state) {
                              if(state is CheckoutLoading){
                                return Center(child: LoadinWidget(),);
                              }
                              if(state is CheckoutError){
                                return Center(child: CustomText(text: state
                                    .message,color: Colors.red),);
                              }
                              if(state is CheckoutLoaded){
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.carts.items.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final  product = state.carts.items[index].product ;
                                    final cart = state.carts.items[index];
                                    return ProductWideget(
                                      image: product.image,
                                      name: product.name,
                                      color: cart.color?.name,
                                      size: cart.size?.name,
                                      price: "${cart.total}",
                                      qnt: "${cart.quantity}",
                                    );
                                  },
                                );
                              }
                              return SizedBox();
                            },
                          ),
                          Divider(),

                          Gap(8.h),
                          BlocBuilder<CheckoutCubit,CheckoutState>(
                            builder: (BuildContext context, CheckoutState state) {
                              if(state is CheckoutLoaded){
                                final cart = state.carts;
                                final price = state.cities[0].price;
                                return  Column(children: [
                                  _getTile("sub_total".tr(), "${cart.subtotal}"),
                                  _getTile("delivery_fee".tr(), "$price"),
                                  _getTile("total".tr(), "${cart.subtotal + price}"),
                                ],);
                              }
                              return SizedBox.shrink();

                            },
                          ),


                          SizedBox(
                           width:  double.infinity,
                            height: 50.h,
                            child: BlocBuilder<CheckoutCubit,CheckoutState>(
                              builder: (BuildContext context, CheckoutState state) {
                                final loading = state is CheckoutLoaded;
                               return ElevatedButton(
                                  onPressed: loading
                                      ? () {

                               GoRouter.of(context).pushNamed(AppRoutes.checkout_tow);

                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: CustomText(
                                    text: "الانتقال لبيانات الدفع",
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                          Gap(50.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTile( name,  price ) {
    return  ListTile(
      title: CustomText(text: name, size: 16, color: AppColors.primary),
      trailing: CustomText(
        text: "$price ₪",
        size: 16,
        color: AppColors.primary,
      ),
    );
  }
}
