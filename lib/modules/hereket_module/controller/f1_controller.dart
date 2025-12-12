import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/hereket_module/models/apply_dto.dart';

import 'package:hbmarket/modules/hereket_module/models/daime.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dplan.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';

import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/hereket_module/models/update_apply.dart';

import 'package:hbmarket/modules/hereket_module/models/work_item.dart';
import 'package:hbmarket/modules/hereket_module/service/hereket_service.dart';
import 'package:hbmarket/modules/hereket_module/widget/work_widget_bkp1.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';

import '../../common/api_helper.dart';

class F1Controller extends GetxController {
  TextEditingController? activeController;
  late final HereketService service;
  bool isLoading = false;
  String errorMessage = '';
  @override
  void onInit() {
    super.onInit();
    service = HereketService(client: ApiClient());
  }

  void setActiveController(TextEditingController ctrl){
     activeController = ctrl;
     update();
  }



  Future<void> saveDplan(
      HereketDPlan dto,
      ) async{
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('dbId.....->${dbId}');
      await service.ok(dbId, dto);
      debugPrint('f1 ${dto}');

    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }
}
