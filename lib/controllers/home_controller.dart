part of 'controllers.dart';

class HomeController extends GetxController {
  Rx<List?> listExploreWellness = Rx<List?>(null);

  Future<bool> getListExploreWellness() async {
    try {
      if (listExploreWellness.isRxNull) listExploreWellness([]);

      return false;
    } on FormatException catch (e) {
      if (listExploreWellness.isRxNull) listExploreWellness([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      if (listExploreWellness.isRxNull) listExploreWellness([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      if (listExploreWellness.isRxNull) listExploreWellness([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      if (listExploreWellness.isRxNull) listExploreWellness([]);
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }
}
