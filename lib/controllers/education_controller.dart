part of 'controllers.dart';

class EducationController extends GetxController {
  final ApiService _apiService = ApiService();

  final DatabaseController _databaseController = Get.find();

  final TextEditingController searchController = TextEditingController();

  Rx<List?> listContent = Rx<List?>(null);
  Rx<List> selectedCategory = Rx<List>([]);
  Rx<List> selectedContent = Rx<List>([]);

  final Rx<int> page = Rx<int>(1);
  final Rx<int> size = Rx<int>(10);
  final Rx<String> search = Rx<String>('');
  final Rx<bool> hasReachedMaxPage = Rx<bool>(false);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<bool> getListContent({required bool isRefresh}) async {
    try {
      /// Declare variable
      bool result = false;

      if (isRefresh) {
        page(1);
        hasReachedMaxPage(false);
      }

      List<String> params = [
        'page=$page',
        'size=$size',
        'sort=published_at DESC',
        [
          if (searchController.text.trim().isNotEmpty)
            'query=search:${searchController.text.trim()}',
          if (selectedCategory.value.isNotEmpty)
            'category_name:${selectedCategory.value.join('|')}',
          if (selectedContent.value.isNotEmpty)
            'content_format:${selectedContent.value.join('|')}',
        ].join(',')
      ];

      String url =
          'https://backend-api.emtrade.link/content/public/v1/post?${params.join('&')}';

      print(url);
      var response = await _apiService.getData(url: url);
      dynamic decoded = jsonDecode(response.body);
      search(searchController.text.trim());

      if (decoded != null) {
        List? temp = decoded?['data'];
        int currentPage = decoded?['current_page'];
        int totalPage = decoded?['total_page'];

        if (temp != null && temp.isNotEmpty) {
          if (isRefresh || listContent.isRxNull) listContent([]);
          listContent.update((_) => listContent.value?.addAll(temp));
        } else {
          if (listContent.isRxNull) listContent([]);
        }

        if (currentPage == totalPage) {
          hasReachedMaxPage(true);
        } else {
          page(page.value + 1);
        }
      } else {
        if (listContent.isRxNull) listContent([]);
        SharedWidget.renderDefaultSnackBar(
          title: 'Error',
          message: '${decoded?['message']}',
          isError: true,
        );
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'getListExploreWellness',
          url: url,
          method: 'GET',
          header: response.headers,
          body: {},
          response: decoded);

      return result;
    } on FormatException catch (e) {
      if (listContent.isRxNull) listContent([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (listContent.isRxNull) listContent([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (listContent.isRxNull) listContent([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (listContent.isRxNull) listContent([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }
}
