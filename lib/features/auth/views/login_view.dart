import 'package:aycel/core/constant/app_seting.dart';
import 'package:aycel/features/auth/data/cubit/auth_cubit.dart';
import 'package:aycel/features/auth/data/cubit/auth_state.dart';
import 'package:aycel/features/auth/widgets/auth_button.dart';
import 'package:aycel/features/shared_widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../widgets/text_edit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthSuccess) {

          GoRouter.of(context).pushReplacementNamed(AppRoutes.root);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(
                text: state.message,
                color: Colors.white,
                size: 16,
                maxLines: 2,
              ),
              backgroundColor: Colors.red,
              elevation: 2,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.background),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(50.h),
                    CustomText(text: AppSetting.appName, size: 25),
                    Gap(20.h),
                    Container(
                      width: double.infinity,
                      height: 600.h,
                      padding: EdgeInsets.all(32.sp),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomText(text: 'login'.tr(), size: 20),
                            Gap(4.h),
                            CustomText(text: 'welcome_text'.tr(), size: 12),
                            Gap(48.h),
                            TextEdit(
                              lable: 'phone'.tr(),
                              controller: _phoneController,
                              icon: Icons.phone_outlined,
                            ),
                            Gap(24.h),
                            TextEdit(
                              lable: 'password'.tr(),
                              controller: _passwordController,
                              icon: Icons.lock_outlined,
                              isPassword: true,
                            ),
                            Gap(50.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (BuildContext context, AuthState state) {
                                final loading = state is AuthLoading;
                                return AuthButton(
                                  text: 'login'.tr(),
                                  isLoading: state is AuthLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(
                                        phone: _phoneController.text,
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            Gap(40.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(thickness: 3, color: Colors.black),
                                Gap(10.h),
                                CustomText(text: 'or'.tr(), size: 12),
                                Gap(10.h),
                                Divider(thickness: 3, color: Colors.black),
                              ],
                            ),
                            Gap(10.h),
                            InkWell(
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).pushReplacementNamed(AppRoutes.register);
                              },

                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Cairo',
                                    color: Colors.black87,
                                  ),
                                  children: [
                                    TextSpan(text: 'no_account'.tr()),
                                    TextSpan(
                                      text: 'sign_up'.tr(),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
