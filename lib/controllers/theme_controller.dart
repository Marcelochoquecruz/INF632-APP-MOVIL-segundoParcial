// lib/controllers/theme_controller.dart
import 'package:get/get.dart';
class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    // Inicializar con tema claro
    updateTheme(false);
  }

  void toggleTheme() {
    updateTheme(!_isDarkMode.value);
  }

  void updateTheme(bool darkMode) {
    _isDarkMode.value = darkMode;
  }
}
