import 'package:assessment/view/screen/auth/login.dart';
import 'package:assessment/view/screen/auth/register.dart';
import 'package:assessment/view/screen/home.dart';
import 'package:assessment/view/screen/profile.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes{
  List<GetPage<dynamic>>? pageRoutes = [
    GetPage(name: "/", page: () => const Login()),
    GetPage(name: "/register", page: () => const Register()),
    GetPage(name: "/home", page: () => const Home()),
    GetPage(name: "/profile", page: () => const Profile()),
  ];
}