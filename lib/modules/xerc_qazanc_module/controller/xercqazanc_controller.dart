
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/service/xerc_service.dart';

class XercQazancController extends GetxController with ColumnVisibilityMixin {
  // final KassaController kassaController = Get.put(KassaController());
  // final KassaController kassaController = Get.find<KassaController>();
  final PartnyorController partnyorController = Get.put(PartnyorController());
  List<XercQazanc> xercs = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  late final XercQazancService service;
  final box = GetStorage();

  int? _selectedMustId;
  XercQazanc? _selectedItem;

  int? get selectedMustId => _selectedMustId;
  XercQazanc? get selectedItem => _selectedItem;

  void setSelectItem(XercQazanc item) {
    _selectedItem = item;
    print('_selectedItem...${_selectedItem}');
    update(); // to refresh GetBuilder
  }

  void selectFirstIfNull() {
    if (selectedMustId == null && xercs.isNotEmpty) {
      _selectedMustId = xercs.first.id;
      _selectedItem = xercs.first;
    }
  }

  void selectPartnyor(int id) {
    _selectedMustId = id;
    print('selected Partnyor ...$_selectedMustId');
    update(); // triggers GetBuilder rebuild
  }

  @override
  void onInit() {
    super.onInit();

    initColumns('xercQazancColumns', [
      {'key': 'id', 'label': 'No', 'visible': true},
      {'key': 'mad', 'label': 'Partnyor', 'visible': true},
      {'key': 'mebleg', 'label': 'Məb', 'visible': true},
      {'key': 'oden', 'label': 'Ödən.', 'visible': true},
      {'key': 'kad', 'label': 'Kassa', 'visible': true},
      {'key': 'xkatAd', 'label': 'Kat.', 'visible': true},
      {'key': 'xakatAd', 'label': 'Alt k.', 'visible': true},
      {'key': 'sebeb', 'label': 'Sebeb', 'visible': true},
      {'key': 'qeyd', 'label': 'Qeyd', 'visible': true},
    ]);

    service = XercQazancService(client: ApiClient());

    // debugPrint('before service called');
    // fetchXercQazanc();
  }

  Future<void> fetchXercQazanc() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('dbId in XercQazanc.....->${dbId}');
      xercs = await service.fetchXerc(dbId);
      if (xercs.isNotEmpty && _selectedItem !=null){
        _selectedItem = xercs.first;
      }
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveYeniXerc(XercRequestDto dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('xercrequest.... ${dto.toJson()}');

      // Example: call your backend API
      // int res = await service.xercYeni(dbId, mustId, kassaId, amount, tip);
      int res = await service.xercYeni(dbId, dto);
      if (res == 200) {
        fetchXercQazanc();
      }

      // Update local list if needed
      update();
      Get.snackbar('Success', 'Xərc uğurla yadda saxlanıldı!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> saveXercDuzelis(XercRequestDto dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      int res = await service.xercUpdate(dbId, dto);
      if (res == 200) {
        fetchXercQazanc();
      }
      update();
      Get.snackbar('Success', 'Xərc uğurla yadda saxlanıldı!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
