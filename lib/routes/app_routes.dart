// lib/routes/app_routes.dart
import 'package:get/get.dart';
import '../views/main_view.dart';
import '../views/home_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const MainView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/home',
      page: () => HomeView(),
      transition: Transition.cupertino,
    ),
  ];
}