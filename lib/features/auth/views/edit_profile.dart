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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? user;
  @override
  Widget build(BuildContext context) {
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
            text: "edit_profile".tr(),
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (state is ProfileError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadinWidget(size: 20,color: Colors.black,),
                Gap(16.h),

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
                Gap(12.h),
                CustomText(
                  text: state.message,
                  size: 16,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                Gap(16.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().getProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text(
                    "إعادة المحاولة",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded ||
            state is ImageSelected ||
            state is ProfileUpdatating ||
            state is ProfileUpdated ||
            state is ProfileError) {
          return _buildProfileContent(context, state);
        }

        return const SizedBox.shrink();
      },
      ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, AuthState state) {
    final cubit = context.read<AuthCubit>();
     user = cubit.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    // ✅ تحديد إذا كان جاري التحديث
    final isLoading = state is ProfileUpdatating;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================
          /// صورة الملف الشخصي
          /// =========================
          Form(
            key: cubit.formKey,
            child: Center(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.w,
                        color: AppColors.secondary,
                      ),
                    ),
                    child: ClipOval(
                      child: cubit.selectedImage != null
                          ? Image.file(
                        cubit.selectedImage!,
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                      )
                          : CachedNetworkImage(
                        imageUrl: user!.image,
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: LoadinWidget(),
                        ),
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                  ),

                  if (isLoading)
                    Container(
                      width: 133.w,
                      height: 133.h,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),

                  /// ✅ زر الكاميرا
                  Positioned(
                    bottom: 5.h,
                    right: 5.w,
                    child: InkWell(
                      onTap: isLoading ? null : showImagePickerDialog,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: isLoading ? Colors.grey : AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.w,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Gap(35.h),

          /// =========================
          /// حقل الاسم
          /// =========================
          TextEdit(
            lable: 'name'.tr(),
            controller: cubit.nameController,
            icon: Icons.drive_file_rename_outline,
          ),

          Gap(22.h),

          /// =========================
          /// حقل رقم الهاتف
          /// =========================
          TextEdit(
            lable: 'phone'.tr(),
            controller: cubit.phoneController,
            icon: Icons.phone,
          ),

          Gap(40.h),

          /// =========================
          /// زر التحديث
          /// =========================
          AuthButton(
            text: 'update_profile'.tr(),
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () {
              if (cubit.formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                cubit.updateProfile(
                  phone: cubit.phoneController.text.trim(),
                  name: cubit.nameController.text.trim(),
                  image: cubit.selectedImage?.path,
                );
              }
            },
          ),

          Gap(20.h),
        ],
      ),
    );
  }

  /// ============================================================
  /// حوار اختيار الصورة
  /// ============================================================
  void showImagePickerDialog() {
    final cubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomText(
            text: "اختر صورة".tr(),
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ✅ معرض الصور
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
                title: CustomText(
                  text: "chose_from_gallery".tr(),
                  size: 16,
                ),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await cubit.pickImage(ImageSource.gallery);
                },
              ),

              const Divider(),

              /// ✅ الكاميرا
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
                title: CustomText(
                  text: "chose_from_camera".tr(),
                  size: 16,
                ),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await cubit.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}