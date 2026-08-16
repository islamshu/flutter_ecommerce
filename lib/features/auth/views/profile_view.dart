import 'package:aycel/core/constant/app_colors.dart';
import 'package:aycel/core/router/app_routes.dart';
import 'package:aycel/features/auth/data/cubit/auth_cubit.dart';
import 'package:aycel/features/auth/data/cubit/auth_state.dart';
import 'package:aycel/features/shared_widgets/custom_text.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../widgets/auth_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
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
          title: CustomText(text: "profile".tr()),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: BlocBuilder<AuthCubit,AuthState>(
                      builder: (BuildContext context, AuthState state) {
                        debugPrint(state.runtimeType.toString());

                        if(state is  UserLoading){
                          return Container(height:100.h,width:double.infinity,child: Center(child: LoadinWidget(),));
                        }
                        if(state is UserLoaded){
                            final cubit = context.read<AuthCubit>();
                            final user = cubit.user;

                          return  Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3.sp),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.w,
                                          color: AppColors.secondary,
                                        ),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.circular(
                                          19.r,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: user!.image,
                                          fit: BoxFit.fill,
                                          width: 100.w,
                                          height: 100.h,
                                          placeholder: (context, url) => const Center(
                                            child: LoadinWidget(),
                                          ),
                                          errorWidget: (context, url, error) {
                                            return const Icon(Icons.broken_image);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: user!.name,
                                        size: 17,
                                        maxLines: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Gap(4),
                                      CustomText(
                                        text: user!.phoneNumber,
                                        size: 16,
                                        maxLines: 2,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is UserError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60.sp,
                                ),
                                Gap(12),
                                CustomText(
                                  text: state.message,
                                  size: 16,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                                Gap(16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().getProfile();
                                  },
                                  child:  CustomText(text: "retry".tr(),),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                  Gap(8.h),
                  CustomText(text: "edit_account".tr()),
                  _boxProfile(Icon(Icons.edit), "edit_profile".tr(), () {
                    GoRouter.of(context).pushNamed(AppRoutes.editProfile);
                  }),
                  _boxProfile(
                    Icon(Icons.change_circle),
                    "change_password".tr(),
                    () {
                      GoRouter.of(context).pushNamed(AppRoutes.editPassword);
                    },
                  ),
                  _boxProfile(Icon(Icons.favorite), "wishlist".tr(), () {
                    GoRouter.of(context).pushNamed(AppRoutes.wishlist);
                  }),
                  _boxProfile(Icon(Icons.reorder), "orders".tr(), () {
                    GoRouter.of(context).pushNamed(AppRoutes.orders);

                  }),
                  _boxProfile(Icon(Icons.notifications), "الاشعارات", () {}),
                  Gap(60.h),
                  Center(
                    child: SizedBox(
                      width: 220.w,
                      height: 60.h,

                      child: BlocConsumer<AuthCubit,AuthState>(
                        builder: (BuildContext context, AuthState state) {
                          return AuthButton(
                            color: Colors.red,
                            text: 'logout'.tr(),
                            isLoading: state is UserLogout,
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                            },
                          );
                        }, listener: (BuildContext context, AuthState state) {
                          if(state is UserLogoedOut){
                            GoRouter.of(context).pushReplacementNamed(AppRoutes.login);
                          }
                          if(state is UserError){
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                      },
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

  Widget _boxProfile(icon, name, onTap) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ListTile(
          leading: icon,
          title: CustomText(text: name, size: 16, color: AppColors.primary),
          trailing: InkWell(onTap: onTap, child: Icon(Icons.arrow_forward_ios)),
        ),
      ),
    );
  }
}
