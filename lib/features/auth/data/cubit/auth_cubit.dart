import 'dart:io';

import 'package:aycel/core/network/api_error.dart';
import 'package:aycel/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(AuthInit()) {
    getProfile();
  }

  UserModel? user;
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  final AuthRepo _authRepo;

  File? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image == null) return;

      selectedImage = File(image.path);

      emit(ImageSelected());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(AuthLoading());

    try {
      await _authRepo.login(phone, password);

      emit(AuthSuccess());
    } catch (e) {
      String errorMsg = "Something error";

      if (e is ApiError) {
        errorMsg = e.message;
      }

      emit(AuthError(errorMsg));
    }
  }

  Future<void> register({
    required String name,
    required String phone,
    required String password,
    required String confirm_password,
  }) async {
    emit(AuthLoading());

    try {
      await _authRepo.register(name, phone, password, confirm_password);

      emit(AuthSuccess());
    } catch (e) {
      String errorMsg = "Something error";

      if (e is ApiError) {
        errorMsg = e.message;
      }

      emit(AuthError(errorMsg));
    }
  }

  Future<void> getProfile() async {
    debugPrint("getProfile called");

    emit(UserLoading());

    try {
      user = await _authRepo.get_user();

      if (user == null) {
        emit(UserError("لم يتم العثور على بيانات المستخدم"));
        return;
      }

      nameController.text = user!.name;
      phoneController.text = user!.phoneNumber;

      selectedImage = null;

      emit(UserLoaded(user: user!));
    } catch (e) {
      debugPrint("getProfile error: $e");

      String errorMsg = "حدث خطأ أثناء تحميل البيانات";

      if (e is ApiError) {
        errorMsg = e.message;
      }

      emit(UserError(errorMsg));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? image,
  }) async {
    emit(ProfileUpdatating());

    try {
      user = await _authRepo.updateProfile(
        name: name,
        phone: phone,
        image: image,
      );

      if (user == null) {
        emit(ProfileError(error: "لم يتم تحديث البيانات"));
        return;
      }

      nameController.text = user!.name;
      phoneController.text = user!.phoneNumber;
      selectedImage = null;

      emit(ProfileUpdated(user: user!, message: "profile_updated".tr()));
    } catch (e) {
      debugPrint("updateProfile error: $e");

      String errorMsg = "حدث خطأ أثناء تحديث الملف الشخصي";

      if (e is ApiError) {
        errorMsg = e.message;
      } else if (e is DioException) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          errorMsg =
              data['message']?.toString() ??
              data['error']?.toString() ??
              errorMsg;
        } else if (data is String) {
          debugPrint("Server response: $data");
          errorMsg = "خطأ من الخادم (${e.response?.statusCode})";
        } else if (e.message != null) {
          errorMsg = e.message!;
        }
      }

      emit(ProfileError(error: errorMsg));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(UserLoading());
    try {
      await _authRepo.changePassword(
        currentPassword,
        newPassword,
        confirmNewPassword,
      );

      emit(PasswordUpdated());
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(UserLogout());
    try {
      await _authRepo.logout();
      emit(UserLogoedOut());
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();

    return super.close();
  }
}
