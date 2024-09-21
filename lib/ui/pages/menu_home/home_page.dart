import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../models/custom_item_menu.dart';
import '../../../extensions/extensions.dart';
import '../../../controllers/controllers.dart';
import '../../../models/custom_item_dropdown.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();
  final ThemeController _themeController = Get.find();

  final RefreshController _refreshController = RefreshController();

  final Rx<bool> _isEmployee = Rx<bool>(false);
  late final Rx<String> _selectedFilterWellness =
      Rx<String>(_menusDropdown.first.id);

  final List<CustomItemDropdown> _menusDropdown = [
    CustomItemDropdown(
      id: 'Popular',
      label: 'Terpopuler',
      icon: IconlyLight.profile,
    ),
    CustomItemDropdown(
      id: 'AtoZ',
      label: 'A to Z',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'ZtoA',
      label: 'Z to A',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'lowestPrice',
      label: 'Harga Terendah',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'highestPrice',
      label: 'Harga Tertinggi',
      icon: IconlyLight.logout,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_homeController.listExploreWellness.isRxNull) {
      _homeController.getListExploreWellness();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void onRefresh() {
    Future.wait([
      _homeController.getListExploreWellness(),
    ]).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeController.primaryColor200.value,
      appBar: CustomAppBarWidget(
        backgroundColor: _themeController.primaryColor200.value,
        canReturn: false,
        titleText: 'Selamat ${SharedMethod.getGreetings()}, Adi Purwanto',
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: false,
        actions: [
          const SizedBox(width: 8),
          CustomAppBarWidget.renderAppbarButton(
            icon: Iconsax.notification5,
            badge: '10',
            iconColor: Colors.white,
            buttonColor: Colors.white.withOpacity(.2),
            onTap: () {},
          ),
          const SizedBox(width: 8),
          Obx(() => CustomAppBarWidget.renderCircleAvatar(
                iconColor: Colors.white,
                buttonColor: Colors.white.withOpacity(.2),
              )),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          controller: _refreshController,
          header: MaterialClassicHeader(
              backgroundColor: _themeController.primaryColor200.value,
              color: Colors.white),
          onRefresh: onRefresh,
          child: renderBody(),
        ),
      ),
    );
  }

  Widget renderBody() {
    Widget renderTitle({
      required String title,
      Widget? child,
    }) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          if (child != null) child,
        ],
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: SharedValue.defaultPadding),
        padding:
            const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding)
                .copyWith(bottom: 90),
        constraints: BoxConstraints(minHeight: Get.height),
        decoration: BoxDecoration(
          color: _themeController.getPrimaryBackgroundColor.value,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_themeController.getThemeBorderRadius(20)),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: SharedValue.defaultPadding),
            CustomSlidingSegmentedControl<bool>(
              height: 33,
              fromMax: true,
              isStretch: true,
              initialValue: _isEmployee.value,
              innerPadding: const EdgeInsets.all(4),
              children: {
                false: AnimatedDefaultTextStyle(
                  maxLines: 1,
                  duration: const Duration(milliseconds: 200),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _isEmployee.value == false
                          ? Colors.white
                          : _themeController.getPrimaryTextColor.value,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: _isEmployee.value == false ? 13 : 12),
                  child: const Text('Semua Menu'),
                ),
                true: AnimatedDefaultTextStyle(
                  maxLines: 1,
                  duration: const Duration(milliseconds: 200),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _isEmployee.value == true
                          ? Colors.white
                          : _themeController.getPrimaryTextColor.value,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: _isEmployee.value == true ? 13 : 12),
                  child: const Text('Menu Karyawan'),
                ),
              },
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(20)),
                color: _themeController.getSecondaryBackgroundColor.value,
                boxShadow: _themeController.getShadowProfile(mode: 2),
              ),
              thumbDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _themeController.primaryColor200.value,
              ),
              onValueChanged: (value) => _isEmployee(value),
            ),
            const SizedBox(height: SharedValue.defaultPadding),
            renderTitle(title: 'Produk Keuangan'),
            const SizedBox(height: SharedValue.defaultPadding),
            CustomMasonryWidget(
              mainAxisCount: 2,
              crossAxisCount: CustomResponsiveWidget.value(context,
                  whenMobile: 4, whenTablet: 5, whenDesktop: 6),
              itemMenus: [
                CustomItemMenu(
                  name: 'Urun',
                  badge: 'NEW',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-users.svg',
                ),
                CustomItemMenu(
                  name: 'Pembiayaan Porsi Haji',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-mosque.svg',
                ),
                CustomItemMenu(
                  name: 'Financial\nCheck Up',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-bank.svg',
                ),
                CustomItemMenu(
                  name: 'Asuransi\nMobil',
                  iconSize: 40,
                  svgAsset: 'assets/icons/svg_asset-car.svg',
                ),
                CustomItemMenu(
                  name: 'Asuransi\nProperti',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-building.svg',
                ),
              ],
            ),
            const SizedBox(height: SharedValue.defaultPadding * 2),
            renderTitle(
              title: 'Kategori Pilihan',
              child: CustomButton(
                height: 25,
                color: Colors.grey.withOpacity(.3),
                padding: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding / 1.5),
                borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(30),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: SharedValue.defaultPadding / 2),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: _themeController.primaryColor200.value,
                      child: const Text(
                        '0',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: SharedValue.defaultPadding),
            CustomMasonryWidget(
              mainAxisCount: 2,
              crossAxisCount: CustomResponsiveWidget.value(context,
                  whenMobile: 4, whenTablet: 5, whenDesktop: 6),
              itemMenus: [
                CustomItemMenu(
                  name: 'Hobi',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-beach.svg',
                ),
                CustomItemMenu(
                  name: 'Merchandise',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-shirt.svg',
                ),
                CustomItemMenu(
                  name: 'Gaya Hidup\nSehat',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-heart.svg',
                ),
                CustomItemMenu(
                  name: 'Konseling &\nRohani',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-chat.svg',
                ),
                CustomItemMenu(
                  name: 'Self\nDevelopment',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-brain.svg',
                ),
                CustomItemMenu(
                  name: 'Perencanaan\nKeuangan',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-card.svg',
                ),
                CustomItemMenu(
                  name: 'Konsultasi\nMedis',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-mask.svg',
                ),
                CustomItemMenu(
                  name: 'Kuliner',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-food.svg',
                ),
                CustomItemMenu(
                  name: 'Kebutuhan\nHarian',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-shop.svg',
                ),
                CustomItemMenu(
                  name: 'Pulsa dan Listrik',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-electrical.svg',
                ),
                CustomItemMenu(
                  name: 'Donasi',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-donate.svg',
                ),
                CustomItemMenu(
                  name: 'Perangkat Kerja',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-work.svg',
                ),
              ],
            ),
            const SizedBox(height: SharedValue.defaultPadding * 2),
            renderTitle(
              title: 'Explore Wellness',
              child: CustomDropdownWidget<String>(
                buttonHeight: 25,
                value: _selectedFilterWellness.value,
                onChanged: (value) => _selectedFilterWellness(value),
                buttonDecoration: BoxDecoration(
                  border: const Border(),
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(30),
                  ),
                ),
                items: List.generate(
                  _menusDropdown.length,
                  (i) => DropdownMenuItem<String>(
                    value: _menusDropdown[i].id,
                    child: Text(
                      _menusDropdown[i].label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _themeController.getPrimaryTextColor.value),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SharedValue.defaultPadding),
            _homeController.listExploreWellness.isRxNull
                ? WaitingWidget()
                : _homeController.listExploreWellness.value?.isEmpty ?? true
                    ? const EmptyWidget()
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 220,
                          mainAxisSpacing: SharedValue.defaultPadding,
                          crossAxisSpacing: SharedValue.defaultPadding,
                          crossAxisCount: CustomResponsiveWidget.value(context,
                              whenMobile: 2, whenTablet: 3, whenDesktop: 4),
                        ),
                        itemBuilder: (context, index) =>
                            generateItemWellness(index),
                      ),
          ],
        ),
      ),
    );
  }

  Widget generateItemWellness(int index) {
    var data = _homeController.listExploreWellness.value?[index];

    return CustomCardWidget(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            width: Get.width,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  _themeController.getThemeBorderRadius(10),
                ),
              ),
              child: CustomCacheImage(
                imageUrl: data?['image_url'],
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: PaddingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: const EdgeInsets.all(SharedValue.defaultPadding / 2),
              children: [
                Text(
                  SharedMethod.valuePrettier(data['title']),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const Spacer(flex: 2),
                Row(
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        SharedMethod.formatValueToCurrency(data['price'],
                            decimalDigits: 0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              '${data['discount_percentage']}' != '0' ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: '${data['discount_percentage']}' != '0'
                              ? _themeController.getSecondaryTextColor.value
                              : _themeController.getPrimaryTextColor.value,
                          decoration: '${data['discount_percentage']}' != '0'
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: '${data['discount_percentage']}' != '0',
                        child: const SizedBox(width: 5)),
                    Visibility(
                      visible: '${data['discount_percentage']}' != '0',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            _themeController.getThemeBorderRadius(5),
                          ),
                        ),
                        child: Text(
                          '${SharedMethod.formatValueToDecimal(data['discount_percentage'])}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: '${data['discount_percentage']}' != '0',
                  child: AutoSizeText(
                    SharedMethod.formatValueToCurrency(data['discount_price'],
                        decimalDigits: 0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
