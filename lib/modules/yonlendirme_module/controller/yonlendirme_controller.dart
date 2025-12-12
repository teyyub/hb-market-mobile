import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/temizlenme_module/models/temizle_model.dart';
import 'package:hbmarket/modules/yonlendirme_module/models/yonlendirme_model.dart';
import 'package:hbmarket/modules/yonlendirme_module/service/yonlendirme_service.dart';

import '../../login_module/controller/db_selection_controller.dart';

class YonlendirmeController extends GetxController {
  final YonlendirmeService service = YonlendirmeService(client: ApiClient());

  List<YonlendirmeDto> yonlendirmeList = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchYonlendirme();
  }

  Future<void> fetchYonlendirme() async {
    isLoading = true;
    update();
    try {
      final data = await service.fetchAll();
      yonlendirmeList = data;
    } catch (e) {
      print('Error fetching temizlenme: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // Future<void> updateYonlendirme(YonlendirmeDto item, bool val) async {
  //   try {
  //     await service.updateYonlendirme(item.id!, val));
  //     // Update local list
  //     int index = temizlenmeList.indexWhere((e) => e.id == item.id);
  //     if (index != -1) {
  //       temizlenmeList[index] = item.copyWith(date: newDate);
  //     }
  //     temizlenmeList.refresh(); // update UI
  //   } catch (e) {
  //     print('Error updating date: $e');
  //   }
  // }

  Future<void> updateKecidOk(YonlendirmeDto item, bool val) async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      final updatedDto = item.copyWith(kecidOk: val);
      // await service.updateYonlendirme(item.id!, updatedDto);
      await service.updateYonlendirmeV1(dbId, updatedDto);
      // update local list
      int index = yonlendirmeList.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        yonlendirmeList[index] = item.copyWith(kecidOk: val);
      }
      update(); // notify UI
    } catch (e) {
      print('Error updating kecidOk: $e');
    }
  }
}
