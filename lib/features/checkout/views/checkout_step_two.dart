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
import '../../auth/widgets/text_edit.dart';
import '../../shared_widgets/custom_text.dart';
import '../../shared_widgets/loadin_widget.dart';
import '../data/city_model.dart';
import '../data/cubit/checkout_cubit.dart';
import '../data/cubit/checkout_state.dart';

class CheckoutStepTwo extends StatelessWidget {
  const CheckoutStepTwo({super.key});

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

        appBar: AppBar(
          centerTitle: true,
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
                    text: "بيانات الدفع".tr(),
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
                          Divider(),
                          Gap(12.h),
                          Row(
                            children: [
                              CustomText(
                                text: "select_city".tr(),
                                size: 16,
                                fontWeight: FontWeight.w600,
                              ),

                              const Spacer(),

                              BlocBuilder<CheckoutCubit, CheckoutState>(
                                builder: (context, state) {
                                  if (state is CheckoutLoaded) {
                                    return SizedBox(
                                      width: 180.w,
                                      height: 55.h,
                                      child: DropdownMenu<CityModel>(
                                        hintText: "choose_address".tr(),
                                        leadingIcon: const Icon(
                                          Icons.location_on_outlined,
                                        ),

                                        textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),

                                        menuStyle: MenuStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Colors.white,
                                              ),
                                          elevation: WidgetStateProperty.all(5),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                          ),
                                        ),

                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                              filled: true,
                                              fillColor: Colors.grey.shade100,

                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 8.h,
                                                  ),

                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13.sp,
                                              ),

                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                borderSide: BorderSide.none,
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                borderSide: BorderSide.none,
                                              ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                borderSide: BorderSide(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                              ),
                                            ),

                                        onSelected: (city) {
                                          if (city != null) {
                                            context
                                                .read<CheckoutCubit>()
                                                .selectCity(city);
                                          }
                                        },

                                        dropdownMenuEntries: state.cities.map((
                                          city,
                                        ) {
                                          return DropdownMenuEntry<CityModel>(
                                            value: city,
                                            label: city.title,
                                            leadingIcon: const Icon(
                                              Icons.location_city_outlined,
                                              size: 20,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                          Gap(8.h),
                          TextEdit(
                            lable: 'first_name'.tr(),
                            controller: context
                                .read<CheckoutCubit>()
                                .firstNameController,
                            icon: Icons.drive_file_rename_outline,
                            fontSize: 15,
                          ),
                          Gap(8.h),

                          TextEdit(
                            lable: 'last_name'.tr(),
                            controller: context
                                .read<CheckoutCubit>()
                                .lastNameController,
                            icon: Icons.drive_file_rename_outline,
                            fontSize: 15,
                          ),
                          Gap(8.h),

                          TextEdit(
                            lable: 'email'.tr(),
                            controller: context
                                .read<CheckoutCubit>()
                                .emailController,
                            icon: Icons.email_outlined,
                            fontSize: 15,
                          ),
                          Gap(8.h),
                          TextEdit(
                            lable: 'phone'.tr(),
                            fontSize: 15,
                            controller: context
                                .read<CheckoutCubit>()
                                .phoneController,
                            icon: Icons.phone_outlined,
                          ),
                          Gap(8.h),
                          TextEdit(
                            lable: 'address'.tr(),
                            fontSize: 15,
                            controller: context
                                .read<CheckoutCubit>()
                                .addressController,
                            icon: Icons.phone_outlined,
                          ),

                          Gap(16.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "اختر طريقة الدفع",
                                size: 14.h,
                              ),
                              Gap(8.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // الدفع عند الاستلام
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<CheckoutCubit>().selectPaymentMethod(
                                          'cod',
                                        );
                                      },
                                      child: Container(
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.r),
                                          color: context.watch<CheckoutCubit>().selectedPaymentMethod ==
                                              'cod'
                                              ? AppColors.primary
                                              : const Color(0xffb6bcbc),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              context
                                                  .watch<CheckoutCubit>()
                                                  .selectedPaymentMethod ==
                                                  'cod'
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_unchecked,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            Gap(8.h),
                                            CustomText(
                                              text: "الدفع عند الاستلام",
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Gap(12.w),

                                  // بال بي
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.read<CheckoutCubit>().selectPaymentMethod(
                                          'paypal',
                                        );
                                      },
                                      child: Container(
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.r),
                                          color: context
                                              .watch<CheckoutCubit>()
                                              .selectedPaymentMethod ==
                                              'paypal'
                                              ? AppColors.primary
                                              : const Color(0xffb6bcbc),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              context
                                                  .watch<CheckoutCubit>()
                                                  .selectedPaymentMethod ==
                                                  'paypal'
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_unchecked,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            Gap(8.h),
                                            CustomText(
                                              text: "باي بال",
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),

                          Gap(8.h),

                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                           child: BlocListener<CheckoutCubit, CheckoutState>(
                          listener: (context, state) {
                            if (state is CheckoutSend) {
                              GoRouter.of(context).pushReplacementNamed(
                                AppRoutes.order,
                                extra: {
                                  "order":state.order,
                                  "isNew": true,
                                }
                              );
                            }
                            if (state is CheckoutError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                ),
                              );
                            }
                          },
                          child: BlocBuilder<CheckoutCubit, CheckoutState>(
                            builder: (context, state) {
                              final loading = state is CheckoutSending;

                              return ElevatedButton(
                                onPressed: loading
                                    ? null
                                    : () {
                                  final cubit = context.read<CheckoutCubit>();

                                  if (cubit.selectedCity == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('يرجى اختيار المدينة'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (cubit.selectedPaymentMethod == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('يرجى اختيار طريقة الدفع'),
                                      ),
                                    );
                                    return;
                                  }
                                  cubit.sendCheckout(
                                    cubit.firstNameController.text,
                                    cubit.lastNameController.text,
                                    cubit.emailController.text,
                                    cubit.phoneController.text,
                                    cubit.selectedPaymentMethod!,
                                    cubit.addressController.text,
                                    cubit.selectedCity!.id,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: loading
                                    ? const LoadinWidget()
                                    : CustomText(
                                  text: "الانتقال للدفع",
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
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
}
