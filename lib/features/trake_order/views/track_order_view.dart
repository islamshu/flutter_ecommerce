import 'package:aycel/core/router/app_routes.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:aycel/features/trake_order/data/cubit/track_cubit.dart';
import 'package:aycel/features/trake_order/data/cubit/track_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';
import 'package:flutter/material.dart' as flutter;
import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_seting.dart';
import '../../shared_widgets/custom_text.dart';

class TrackOrderView extends StatelessWidget {
  const TrackOrderView({super.key});

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

          leading: SizedBox.shrink(),
          title: CustomText(
            text: "track_order".tr(),
            size: 30,
            fontWeight: FontWeight.normal,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: Colors.grey.withValues(alpha: 0.92),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(28.h),
                CustomText(
                  text: "order_number".tr(),
                  size: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                Gap(4.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        cursorColor: AppColors.primary,
                        keyboardType: TextInputType.number,
                        controller: context.read<TrackCubit>().code,
                        decoration: InputDecoration(
                          suffixText: "-ORD",
                          suffixStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                          prefixStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          hintText: "123456",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    SizedBox(
                      height: 50.h,
                      width: 73.w,
                      child: BlocConsumer<TrackCubit, TrackState>(
                        listener: (context, state) {
                          if (state is TrackLoaded) {
                            GoRouter.of(context).pushNamed(
                              AppRoutes.order,
                              extra: {'order': state.order, "isNew": false},
                            );
                          }

                          if (state is TrackErorr) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.erorr)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: state is TrackLoading
                                ? null
                                : () {
                                    context.read<TrackCubit>().get_order(
                                      context
                                          .read<TrackCubit>()
                                          .code
                                          .text
                                          .trim(),
                                    );
                                  },
                            child: state is TrackLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : CustomText(
                                    text: "search".tr(),
                                    size: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
