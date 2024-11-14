import 'package:dartz/dartz.dart';
import '../../back_link.dart';
import '../../core/packages/crud.dart';
import '../../core/packages/statusrequest.dart';

class AuthData{
  Crud crud;
  AuthData(this.crud);
  login(String email, String password) async{
    Either<StatusRequest, Map> response = await crud.postRequest(BackLink.loginLink, {
      "users_email"    : email,
      "users_password" : password,
    }, "");
    return response.fold((StatusRequest l) => l, (Map r) => r);
  }
  loginGoogle(String email, String name) async{
    Either<StatusRequest, Map> response = await crud.postRequest(BackLink.googleLink, {
      "users_email"    : email,
      "users_name" : name,
    }, "");
    return response.fold((StatusRequest l) => l, (Map r) => r);
  }
  register(String name, String email, String password) async{
    Either<StatusRequest, Map> response = await crud.postRequest(BackLink.registerLink, {
      "users_name" : name,
      "users_email"    : email,
      "users_password" : password,
    }, "");
    return response.fold((StatusRequest l) => l, (Map r) => r);
  }
  editProfile(String id, String name, String email, String token) async{
    Either<StatusRequest, Map> response = await crud.postRequest(BackLink.profileLink, {
      "users_id" : id,
      "users_name" : name,
      "users_email"    : email,
    }, token);
    return response.fold((StatusRequest l) => l, (Map r) => r);
  }
}