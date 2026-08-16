import 'package:aycel/core/constant/app_assets.dart';
import 'package:aycel/core/constant/app_colors.dart';
import 'package:aycel/features/auth/data/cubit/auth_cubit.dart';
import 'package:aycel/features/auth/data/cubit/auth_state.dart';
import 'package:aycel/features/auth/data/user_model.dart';
import 'package:aycel/features/shared_widgets/custom_text.dart';
import 'package:aycel/features/shared_widgets/loadin_widget.dart';
import 'package:aycel/features/auth/widgets/text_edit.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/auth_button.dart';

class EditPassword extends StatelessWidget {
   EditPassword({super.key});

  UserModel? user;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Container(
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: "edit_password".tr(),
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.sp),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(35.h),

                TextEdit(
                  lable: 'old_password'.tr(),
                  controller: cubit.oldPasswordController,
                  icon: Icons.password,
                  isPassword: true,
                ),

                Gap(22.h),

                TextEdit(
                  lable: 'new_password'.tr(),
                  controller: cubit.newPasswordController,
                  icon: Icons.password,
                  isPassword: true,
                ),

                Gap(22.h),
                TextEdit(
                  lable: 'confirm_new_password'.tr(),
                  controller: cubit.confirmNewPasswordController,
                  icon: Icons.password,
                  isPassword: true,
                ),

                Gap(22.h),

                BlocConsumer<AuthCubit, AuthState>(
                  builder: (BuildContext context, AuthState state) {
                    final isLoading = state is UserLoading;
                    return AuthButton(
                      text: 'edit_password'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (cubit.formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                cubit.changePassword(
                                  currentPassword: cubit
                                      .oldPasswordController
                                      .text
                                      .trim(),
                                  newPassword: cubit.newPasswordController.text
                                      .trim(),
                                  confirmNewPassword: cubit
                                      .confirmNewPasswordController
                                      .text
                                      .trim(),
                                );
                              }
                            },
                    );
                  },
                  listener: (BuildContext context, AuthState state) {
                    if (state is PasswordUpdated) {
                      cubit.oldPasswordController.clear();
                      cubit.newPasswordController.clear();
                      cubit.confirmNewPasswordController.clear();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text("password_updated".tr())),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text(state.error)),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
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
