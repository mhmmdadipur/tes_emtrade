part of 'controllers.dart';

class MainController extends GetxController {
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<String> selectedItemNavbarId = Rx<String>('home');

  final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

  List<CustomItemNavbar> navbarMenu = [
    CustomItemNavbar(
      id: 'home',
      label: 'Home',
      slug: Routes.home,
      selectedIcon: IconlyLight.home,
      unselectedIcon: IconlyLight.home,
    ),
    CustomItemNavbar(
      id: 'education',
      label: 'Education',
      slug: Routes.education,
      selectedIcon: Iconsax.teacher,
      unselectedIcon: Iconsax.teacher,
    ),
    CustomItemNavbar(
      id: 'stock-pick',
      label: 'Stock Pick',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.diagram,
      unselectedIcon: Iconsax.diagram,
    ),
    CustomItemNavbar(
      id: 'analysis',
      label: 'Analysis',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.presention_chart,
      unselectedIcon: Iconsax.presention_chart,
    ),
    CustomItemNavbar(
      id: 'academy',
      label: 'Academy',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.book,
      unselectedIcon: Iconsax.book,
    ),
    CustomItemNavbar(
      id: 'voucher',
      label: 'Voucher',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.receipt_2,
      unselectedIcon: Iconsax.receipt_2,
    ),
    CustomItemNavbar(
      id: 'friends',
      label: 'Daftar Teman',
      slug: Routes.homeMaintenance,
      selectedIcon: IconlyLight.user_1,
      unselectedIcon: IconlyLight.user_1,
    ),
  ];
}
