import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../extensions/extensions.dart';
import '../models/custom_data_log.dart';
import '../models/custom_data_theme.dart';
import '../models/custom_data_user.dart';
import '../models/custom_item_navbar.dart';
import '../services/api_service.dart';
import '../shared/shared.dart';
import '../routes/routes.dart';
import '../ui/pages/menu_account/otp_verification_page.dart';
import '../ui/widgets/widgets.dart';

part 'database_controller.dart';
part 'education_controller.dart';
part 'home_controller.dart';
part 'main_controller.dart';
part 'splashscreen_controller.dart';
part 'theme_controller.dart';
part 'user_controller.dart';
