import 'package:get/get.dart';

import '../ui/pages/menu_education/education_page.dart';
import '../ui/pages/menu_home/home_page.dart';
import '../ui/pages/menu_account/login_page.dart';
import '../ui/pages/main_page.dart';
import '../ui/pages/maintenance_page.dart';
import '../ui/pages/menu_account/account_page.dart';
import '../ui/pages/menu_account/change_password_page.dart';
import '../ui/pages/menu_logs/logs_detail_page.dart';
import '../ui/pages/menu_logs/logs_page.dart';
import '../ui/pages/splash_screen.dart';

import 'middleware.dart';

class Routes {
  ///! Generic Routes
  static String splashScreen = '/';
  static String login = '/login';
  static String register = '/register';
  static String maintenance = '/404';
  static String home = '/home';
  static String homeMaintenance = '$home/$maintenance';

  ///! Account Routes
  static String education = '/education';

  ///! Account Routes
  static String myAccount = '/my-account';
  static String changePassword = '/change-password';

  ///! Service Routes
  static String logs = '/logs';

  static List<GetPage<dynamic>>? pages = [
    ///! Generic Routes
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      middlewares: [LoginMiddleware()],
      page: () => const LoginPage(child: LoginFormSection()),
    ),
    GetPage(
      name: register,
      middlewares: [LoginMiddleware()],
      page: () => const LoginPage(child: RegisterFormSection()),
    ),
    GetPage(
      name: maintenance,
      page: () => const MaintenancePage(),
    ),
    GetPage(
      name: homeMaintenance,
      page: () => const MainPage(child: MaintenancePage(showBackButton: false)),
    ),
    GetPage(
      name: home,
      page: () => const MainPage(child: HomePage()),
    ),

    ///! Account Routes
    GetPage(
      name: education,
      page: () => const MainPage(child: EducationPage()),
    ),

    ///! Account Routes
    GetPage(
      name: myAccount,
      page: () => const AccountPage(),
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordPage(),
    ),

    ///! Service Routes
    GetPage(
      name: logs,
      middlewares: [AuthMiddleware(), DebugMiddleware()],
      page: () => const LogsPage(),
    ),
    GetPage(
      name: '$logs/:id',
      middlewares: [AuthMiddleware(), DebugMiddleware()],
      page: () => const LogsDetailPage(),
    ),
  ];
}
