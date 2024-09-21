part of 'controllers.dart';

class UserController extends GetxController {
  final DatabaseController _databaseController = Get.find();
  final ThemeController _themeController = Get.find();

  Rx<Map?> user = Rx<Map?>(null);
  Rx<List<GroupRole>> userRole = Rx<List<GroupRole>>([]);
  Rx<List> permissionUser = Rx<List>([]);

  final ApiService _apiService = ApiService();

  bool checkPermission(String permission) =>
      permissionUser.value.contains(permission);

  void updateUserRole() {
    userRole([]);

    userRole.update((_) {
      switch (user.value?['role']) {
        case 'superadmin':
          userRole.value.add(GroupRole.superAdmin);
        case 'admin':
          userRole.value.add(GroupRole.admin);
        case 'employee':
          userRole.value.add(GroupRole.employee);
        default:
          userRole.value.add(GroupRole.anonymous);
      }
    });
  }

  Future<bool> login({
    required String username,
    required String password,
    required bool isRememberMe,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      List<Map> listUser = await _databaseController.getUser(
        usernameOrEmail: username,
        password: password,
      );

      if (listUser.isNotEmpty) {
        Map user = listUser.first;
        List<Map> listUserDetail =
            await _databaseController.getUserDetailByUid(uid: user['id']);

        if (listUserDetail.isNotEmpty) {
          this.user({
            ...listUserDetail.first,
            'username': user['username'],
            'role': user['role'],
          });
          updateUserRole();

          if (isRememberMe) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'login',
                jsonEncode({
                  'username': username,
                  'password': password,
                  'expired':
                      DateTime.now().add(const Duration(days: 14)).toString()
                }));
          }

          Get.offAllNamed(Routes.home);
          result = true;
        } else {
          SharedWidget.renderDefaultSnackBar(
              message: 'User telah dihapus', isError: true);
          result = false;
        }
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: 'User not found', isError: true);
        result = false;
      }

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> register({required Map body}) async {
    try {
      /// Declare variable
      bool result = false;
      const String url = 'https://api.npoint.io/41e4d91ba01172e722d9';

      var response = await _apiService.getData(url: url);

      var decoded = jsonDecode(response.body);

      if (decoded['message'] == null) {
        Get.to(const OtpVerificationPage(), arguments: body);

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: '${decoded['message']}', isError: true);

        result = false;
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'register',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: jsonDecode(response.body));

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> editUser({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? education,
    String? maritalStatus,
    String? nationalId,
    int? provinceId,
    int? regencyId,
    int? districtId,
    int? villageId,
    String? postalCode,
    String? companyName,
    String? companyAddress,
    String? jobTitle,
    String? yearsOfWork,
    String? incomeSource,
    double? annualGrossIncome,
    String? bankName,
    String? bankBranch,
    String? bankAccountNumber,
    String? bankAccountOwnerName,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      bool response = await _databaseController.editUserDetailById(
        uid: user.value?['uid'],
        fullName: fullName ?? user.value?['full_name'],
        email: email ?? user.value?['email'],
        phoneNumber: phoneNumber ?? user.value?['phone_number'],
        dateOfBirth: dateOfBirth ?? user.value?['date_of_birth'],
        gender: gender ?? user.value?['gender'],
        address: address ?? user.value?['address'],
        education: education ?? user.value?['education'],
        maritalStatus: maritalStatus ?? user.value?['marital_status'],
        nationalId: nationalId ?? user.value?['national_id'],
        provinceId: provinceId ?? user.value?['province_id'],
        regencyId: regencyId ?? user.value?['regency_id'],
        districtId: districtId ?? user.value?['district_id'],
        villageId: villageId ?? user.value?['village_id'],
        postalCode: postalCode ?? user.value?['postal_code'],
        companyName: companyName ?? user.value?['company_name'],
        companyAddress: companyAddress ?? user.value?['company_address'],
        jobTitle: jobTitle ?? user.value?['job_title'],
        yearsOfWork: yearsOfWork ?? user.value?['years_of_work'],
        incomeSource: incomeSource ?? user.value?['income_source'],
      );

      if (response) {
        List<Map> listUserDetail = await _databaseController.getUserDetailByUid(
            uid: user.value?['uid']);

        if (listUserDetail.isNotEmpty) {
          user.update((value) => user.value?.addAll(listUserDetail.first));
          updateUserRole();
        }

        SharedWidget.renderDefaultSnackBar(
            message: 'Success edit user', isError: false);

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: 'Something went wrong', isError: true);
        result = false;
      }

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> verifyOTPCode({
    required String username,
    required String password,
    required String pin,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      const String url = 'https://api.npoint.io/41e4d91ba01172e722d9';
      Map<String, dynamic> body = {'user_id': user.value?['id'], 'pin': pin};

      var response = await _apiService.getData(url: url);

      var decoded = jsonDecode(response.body);

      if (decoded['message'] == null) {
        // if (pin == '555555') {
        user(decoded['data']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'login',
            jsonEncode({
              'username': username,
              'password': password,
              'expired': DateTime.now().add(const Duration(days: 14)).toString()
            }));

        Get.offAllNamed(Routes.home);
        updateUserRole();

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: '${decoded['message']}', isError: true);

        result = false;
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'verifyOTPCode',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: jsonDecode(response.body));

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> logout({bool isForceLogout = false}) async {
    try {
      /// Declare variable
      bool result = true;

      if (!isForceLogout) {
        /// API Logout here
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('login');
      prefs.setBool('debugMode', false);
      _themeController.debugMode(false);
      prefs.setBool('historyLog', true);
      _themeController.historyLog(true);

      user.update((val) => user = Rx<Map?>(null));

      Get.offAllNamed(Routes.home);
      updateUserRole();

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }
}
