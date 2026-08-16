import 'package:aycel/features/cart/data/cart_model.dart';
import 'package:aycel/features/cart/data/cubit/cart_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../shared_widgets/custom_text.dart';
import '../../shared_widgets/loadin_widget.dart';
import '../data/cubit/cart_state.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final CartItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, CartItem>(
      selector: (state) {
        final cart = context.read<CartCubit>().cart;

        if (cart != null) {
          final updatedItem = cart.items.firstWhere(
            (e) => e.id == item.id,
            orElse: () => item,
          );

          return updatedItem;
        }

        return item;
      },

      builder: (context, updatedItem) {
        final details = <String>[];

        if (updatedItem.size != null &&
            updatedItem.size!.name.isNotEmpty &&
            updatedItem.size!.name != "null") {

          details.add(
              "${"size".tr()}: ${updatedItem.size!.name}"
          );
        }

        if (updatedItem.color != null &&
            updatedItem.color!.name.isNotEmpty &&
            updatedItem.color != "null") {
          details.add("color".tr()+ ": ${updatedItem.color?.name}");
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

          child: Container(
            width: 360.w,
            height: 410.h,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.transparent.withValues(alpha: 0.2),
            ),

            child: Padding(
              padding: EdgeInsets.all(24.sp),

              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),

                    child: CachedNetworkImage(
                      imageUrl: updatedItem.product.image,

                      width: 350.w,
                      height: 200.h,

                      fit: BoxFit.fitHeight,

                      placeholder: (context, url) =>
                          const Center(child: LoadinWidget()),

                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),

                  Gap(16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(
                            width: 240.w,

                            child: CustomText(
                              text: updatedItem.product.name,
                              size: 18,
                              maxLines: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Gap(4.h),

                          Wrap(
                            spacing: 8,
                            children: details.map((detail) {
                              return CustomText(
                                text: detail,
                                size: 14,
                              );
                            }).toList(),
                          ),
                        ],


                      ),

                      GestureDetector(
                        onTap: onDelete,

                        child: Icon(
                          CupertinoIcons.delete,
                          size: 35,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),

                  Gap(12.h),

                  Row(
                    children: [
                      BlocBuilder<CartCubit,CartState>(
                        builder: (BuildContext context, CartState state) {
                          final loading = context
                              .read<CartCubit>()
                              .updatingItemId == updatedItem.id;


                         return loading ? Center(child: LoadinWidget()) : Container(
                            width: 120.w,

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),

                              borderRadius: BorderRadius.circular(12.r),
                            ),


                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<CartCubit>().increaseQuantity(
                                      updatedItem.id,
                                      updatedItem.quantity + 1,
                                    );
                                  },
                                  icon: const Icon(Icons.add, size: 30,color: Colors.white,),
                                ),

                                CustomText(
                                  text: "${updatedItem.quantity}",

                                  size: 22,

                                  color: Colors.white,

                                  fontWeight: FontWeight.bold,
                                ),

                                IconButton(
                                  onPressed: () {
                                    if (updatedItem.quantity > 1) {
                                      context.read<CartCubit>().decreaseQuantity(
                                        updatedItem.id,
                                        updatedItem.quantity - 1,
                                      );
                                    }
                                  },

                                  icon: const Icon(
                                    Icons.remove,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      Gap(12.w),

                      const Spacer(),

                      CustomText(
                        text: "${updatedItem.total} ₪",

                        color: Colors.white,

                        size: 28,

                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
