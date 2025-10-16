import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/temizlenme_module/models/temizle_model.dart';
import 'package:hbmarket/modules/temizlenme_module/service/temizle_service.dart'; 

class TemizlenmeController extends GetxController {
  final TemizlenmeService service = TemizlenmeService(client: ApiClient());

  var temizlenmeList = <Temizlenme>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTemizlenme();
  }

  Future<void> fetchTemizlenme() async {
    isLoading.value = true;
    try {
      final data = await service.fetchAll();
      temizlenmeList.assignAll(data);
    } catch (e) {
      print('Error fetching temizlenme: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDate(Temizlenme item, DateTime newDate) async {
    try {
      await service.updateDate(item.id, item.copyWith(date: newDate));
      // Update local list
      int index = temizlenmeList.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        temizlenmeList[index] = item.copyWith(date: newDate);
      }
      temizlenmeList.refresh(); // update UI
    } catch (e) {
      print('Error updating date: $e');
    }
  }
}
