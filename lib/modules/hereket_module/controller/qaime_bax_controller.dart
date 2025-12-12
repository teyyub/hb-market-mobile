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
import 'package:hbmarket/modules/hereket_module/models/qaime_bax.dart';
import 'package:hbmarket/modules/hereket_module/models/update_apply.dart';

import 'package:hbmarket/modules/hereket_module/models/work_item.dart';
import 'package:hbmarket/modules/hereket_module/service/hereket_service.dart';
import 'package:hbmarket/modules/hereket_module/widget/work_widget_bkp1.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';

import '../../common/api_helper.dart';

class QaimeBaxController extends GetxController with ColumnVisibilityMixin{
  TextEditingController? activeController;
  late final HereketService service;
  bool isLoading = false;
  String errorMessage = '';
  int? _dPlanId;
  int? get dPlanId => _dPlanId;
  // SET
  set dPlanId(int? value) {
    _dPlanId = value;
  }

  List<QaimeBaxDto> qaimeBaxList = [];

  QaimeBaxDto? _selectedQaimeBax;
  QaimeBaxDto? get getSelectedQaimeBax => _selectedQaimeBax;

  set setQaimeBaxDto(QaimeBaxDto q){
    _selectedQaimeBax = q;
    _dPlanId = q.id;
    debugPrint('selected qaime : ${_selectedQaimeBax?.toJson()}');
    debugPrint('selected dplanid : ${_dPlanId}');
    update();
  }

  @override
  void onInit() {
    super.onInit();

    initColumns('qaimeBaxColumns', [
      {'key': 'id', 'label': 'Id', 'visible': true},
      {'key': 'ad', 'label': 'Ad', 'visible': true},
      {'key': 'barkod', 'label': 'Barkod', 'visible': true},
      {'key': 'miqdar', 'label': 'Miqdar', 'visible': true},
      {'key': 'qiymet', 'label': 'Qiymet', 'visible': true},
      {'key': 'note', 'label': 'Qeyd', 'visible': true},
      // {'key': 'nov', 'label': 'Nov', 'visible': true},
    ]);


    service = HereketService(client: ApiClient());
  }

  void setActiveController(TextEditingController ctrl){
     activeController = ctrl;
     update();
  }



  Future<void> qaimeBax(int dplanId) async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dplanId.....->${dplanId}');
      qaimeBaxList = await service.qaimeBax(dbId, dplanId);
      _selectedQaimeBax  = qaimeBaxList.first;
      debugPrint(' ${qaimeBaxList.length}');
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }

    Future<void> qaimeBaxRedakte(QaimeBaxDto dto) async{
      try {
        final dbKey = DbSelectionController.to.getDbId;
        isLoading = true;
        update();
        errorMessage = '';
        print('dto.....->${dto.toJson()}');
        await service.updateQaime(dbKey, dto);
        int index = qaimeBaxList.indexWhere((q) => q.id == dto.id);
        debugPrint('index:${index}');
        if (index != -1) {
          qaimeBaxList[index] = dto;
          _selectedQaimeBax = dto; // seçilmiş sətiri yenilə
          _dPlanId = dto.id;       // TrinaGrid-də selectedId üçün
          debugPrint('selected qaime : ${_selectedQaimeBax?.toJson()}');
          debugPrint('selected dplanid : ${_dPlanId}');
          update();
        }

      } catch (e) {
        errorMessage = e.toString();
        return null;
      } finally {
        isLoading = false;
        update();
      }
  }
}
