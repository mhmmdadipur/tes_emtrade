import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tes_emtrade/shared/shared.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../widgets/widgets.dart';

class FilterItem {
  final String id;
  final String label;

  FilterItem({required this.id, required this.label});
}

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final EducationController _educationController = Get.find();
  final ThemeController _themeController = Get.find();

  final RefreshController _refreshController = RefreshController();

  List<FilterItem> categoriesList = [
    FilterItem(id: 'insight', label: 'Insight'),
    FilterItem(id: 'pemula', label: 'Pemula'),
    FilterItem(id: 'perencanaan-keuangan', label: 'Perencanaan Keuangan'),
  ];

  List<FilterItem> formatList = [
    FilterItem(id: 'article', label: 'Insight'),
    FilterItem(id: 'video', label: 'Pemula'),
  ];

  @override
  void initState() {
    super.initState();
    if (_educationController.listContent.isRxNull) {
      _educationController.getListContent(isRefresh: true);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void onRefresh() {
    Future.wait([
      _educationController.getListContent(isRefresh: true),
    ]).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  void onLoading() {
    Future.wait([
      _educationController.getListContent(isRefresh: false),
    ]).then((value) {
      _refreshController.loadComplete();
    });
  }

  Future<void> onTapFilterButton() async {
    Rx<List> selectedCategory =
        Rx<List>(_educationController.selectedCategory.deepCopy());

    var result = await SharedWidget.renderDefaultBottomModal(
      titleText: 'Filter',
      subtitle: null,
      crossAxisAlignment: CrossAxisAlignment.start,
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Filter',
              maxLines: 1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          CustomButton(
            height: 30,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding,
            ),
            label: 'Reset',
            style: TextStyle(color: Colors.orange.shade700),
            onTap: () {
              selectedCategory.update((_) => selectedCategory([]));
            },
          ),
        ],
      ),
      content: [
        Container(
          height: 1,
          width: Get.width,
          margin: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Expanded(
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: SharedValue.defaultPadding),
              children: [
                const Text(
                  'Category',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: SharedValue.defaultPadding),
                Wrap(
                  spacing: SharedValue.defaultPadding,
                  runSpacing: SharedValue.defaultPadding / 2,
                  children: List.generate(
                    categoriesList.length,
                    (index) {
                      FilterItem item = categoriesList[index];

                      return CustomButton(
                        onTap: () {
                          if (selectedCategory.value.contains(item.id)) {
                            selectedCategory.update(
                                (_) => selectedCategory.value.remove(item.id));
                          } else {
                            selectedCategory.update(
                                (_) => selectedCategory.value.add(item.id));
                          }
                        },
                        color: selectedCategory.value.contains(item.id)
                            ? _themeController.primaryColor200.value
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: SharedValue.defaultPadding,
                            vertical: SharedValue.defaultPadding / 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: _themeController.getSecondaryTextColor.value
                                .withOpacity(.2),
                          ),
                          borderRadius: BorderRadius.circular(
                            _themeController.getThemeBorderRadius(30),
                          ),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 100),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: selectedCategory.value.contains(item.id)
                                ? Colors.white
                                : _themeController.getPrimaryTextColor.value,
                            fontWeight: _educationController
                                    .selectedCategory.value
                                    .contains(item.id)
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          child: Text(
                            SharedMethod.valuePrettier(item.label),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Container(
          height: 1,
          width: Get.width,
          margin: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        ),
        PaddingRow(
          padding: const EdgeInsets.all(SharedValue.defaultPadding),
          children: [
            Expanded(
              child: CustomButton(
                height: 40,
                onTap: () => Get.back(),
                padding: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: _themeController.getSecondaryTextColor.value
                        .withOpacity(.2),
                  ),
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(30)),
                label: 'Batal',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _themeController.getPrimaryTextColor.value,
                ),
              ),
            ),
            const SizedBox(width: SharedValue.defaultPadding),
            Expanded(
              child: CustomButton(
                height: 40,
                onTap: () => Get.back(result: true),
                padding: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding),
                label: 'Simpan',
                color: Colors.orange.shade700.withOpacity(.1),
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(30)),
                style: TextStyle(
                    color: Colors.orange.shade700, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );

    if (result != null) {
      _educationController.selectedCategory.update((_) =>
          _educationController.selectedCategory(selectedCategory.deepCopy()));
      _educationController.listContent
          .update((_) => _educationController.listContent = Rx<List?>(null));
      _educationController.getListContent(isRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBarWidget(
          canReturn: false,
          centerTitle: false,
          titleText: 'Education',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w700),
          actions: [
            CustomButton(
              height: 30,
              onTap: onTapFilterButton,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: SharedValue.defaultPadding,
              ),
              child: Row(
                children: [
                  Icon(Iconsax.setting_4,
                      size: 20, color: _themeController.primaryColor200.value),
                  const SizedBox(width: SharedValue.defaultPadding / 2),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _themeController.primaryColor200.value,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: Obx(
          () => PaddingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            padding: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding)
                .copyWith(bottom: 78),
            children: [
              CustomTextField(
                height: 40,
                textEditingController: _educationController.searchController,
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(
                  color: _themeController.getSecondaryTextColor.value
                      .withOpacity(.1),
                  borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(30),
                  ),
                ),
                prefixIcon: Icon(IconlyLight.search,
                    size: 20, color: _themeController.secondaryColor100.value),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                hintText: "Cari topik yang kamu mau di sini.",
                hintStyle: const TextStyle(fontSize: 13),
                onSubmitted: (value) {
                  _educationController.listContent.update((_) =>
                      _educationController.listContent = Rx<List?>(null));
                  _educationController.getListContent(isRefresh: true);
                },
              ),
              Visibility(
                  visible: _educationController.search.value.trim().isNotEmpty,
                  child: const SizedBox(height: SharedValue.defaultPadding)),
              Visibility(
                visible: _educationController.search.value.trim().isNotEmpty,
                child: Text(
                  'Hasil Pencarian “${_educationController.searchController.text.trim()}”',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: SharedValue.defaultPadding),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  header: MaterialClassicHeader(
                      backgroundColor: _themeController.primaryColor200.value,
                      color: Colors.white),
                  onRefresh: onRefresh,
                  onLoading: onLoading,
                  enablePullUp: !_educationController.hasReachedMaxPage.value,
                  child: _educationController.listContent.isRxNull
                      ? WaitingWidget()
                      : _educationController.listContent.value?.isEmpty ?? true
                          ? const EmptyWidget(
                              gap: SharedValue.defaultPadding,
                              title: 'Hasil Tidak Ditemukan',
                              subtitle: 'Harap periksa kembali pencarian kamu.',
                            )
                          : renderBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _educationController.listContent.value?.length ?? 0,
      separatorBuilder: (context, index) =>
          const SizedBox(height: SharedValue.defaultPadding),
      itemBuilder: (context, index) =>
          renderContentCard(_educationController.listContent.value?[index]),
    );
  }

  Widget renderContentCard(Map? data) {
    bool isTypeVideo = '${data?['content_format']}'.toLowerCase() == 'video';
    String image = data?['image'] ?? '';
    String thumbnail = data?['thumbnail'] ?? '';

    String usedImage = thumbnail.isNotEmpty
        ? thumbnail
        : image.isNotEmpty
            ? image
            : 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';

    return Container(
      padding: const EdgeInsets.all(SharedValue.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: _themeController.getSecondaryTextColor.value.withOpacity(.2),
        ),
        borderRadius: BorderRadius.circular(
          _themeController.getThemeBorderRadius(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${SharedMethod.valuePrettier(data?['content_format'])} ● ${SharedMethod.valuePrettier(data?['category'])}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: _themeController.getSecondaryTextColor.value,
                    ),
                  ),
                  const Spacer(flex: 1),
                  Text(
                    SharedMethod.valuePrettier(data?['name']),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _themeController.getPrimaryTextColor.value,
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    SharedMethod.valuePrettier(data?['published_at']),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: _themeController.getSecondaryTextColor.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding / 2),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(16),
              ),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(16),
              ),
              child: Stack(
                children: [
                  CustomCacheImage(
                    imageUrl: usedImage,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                  Visibility(
                    visible: isTypeVideo,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                      ),
                      child: const Icon(IconlyBold.play,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
