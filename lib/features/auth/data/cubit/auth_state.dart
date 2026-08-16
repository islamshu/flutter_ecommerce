import 'package:aycel/features/auth/data/user_model.dart';

abstract class AuthState {}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState{}

class AuthSuccess extends AuthState{}
class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
}

class UserLoading  extends AuthState{}
class UserLoaded extends AuthState{
  final UserModel user;
  UserLoaded({required this.user});
}

class UserError extends AuthState{
  final String message;
  UserError(this.message);
}
class ImageSelected extends AuthState {}

class ProfileUpdatating extends AuthState{}
class PasswordUpdated extends AuthState{}
class UserLogout extends AuthState{}

class UserLogoedOut extends AuthState{}

class ProfileUpdated extends AuthState{
  final UserModel user;
  final String message;

  ProfileUpdated({required this.user,required this.message});
}
class ProfileError extends AuthState{
  final String error;
  ProfileError({required this.error});
}