import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/pul_tranfer_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/tranfer_request.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/transfer_response.dart';
import 'package:hbmarket/modules/pul_transfer_module/service/TransferService.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class PulTransferController extends GetxController with ColumnVisibilityMixin {
  List<TransferResponse> transfers = [];
  String searchQuery = '';
  late final TransferService service;
  var errorMessage = '';
  bool isLoading = false;
  int? _selectedId;
  TransferResponse? _selectedTransfer;

  int? get selectedId => _selectedId;
  TransferResponse? get selectedTransfer => _selectedTransfer;

  @override
  void onInit() {
    super.onInit();
    service = TransferService(client: ApiClient());
    initColumns('transfersColumns', [
      {'key': 'id', 'label': 'No', 'visible': true},
      {'key': 'giver', 'label': 'Verən', 'visible': true},
      {'key': 'taker', 'label': 'Alan', 'visible': true},
      {'key': 'amount', 'label': 'Məbləğ', 'visible': true},
      {'key': 'note', 'label': 'Qeyd', 'visible': true},
      // {'key': 'borc', 'label': 'Borc', 'visible': true},
      // {'key': 'tip', 'label': 'Tip', 'visible': true},
      // {'key': 'aktiv', 'label': 'Aktiv', 'visible': true},
    ]);
    fetchTransfers();
  }

  void selectTransfer(int id) {
    debugPrint('selectTransfer...${id}');
    _selectedId = id;
    update(); // refresh the UI
  }

  Future<void> fetchTransfers() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();

      // print('dbId.....->${dbId}');
      transfers = await service.fetchTransfers(dbId);
      print('transfer ${transfers.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveTransfer(TransferRequest dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('transfer.dto.... ${dto.toJson()}');

      // Example: call your backend API
      // int res = await service.xercYeni(dbId, mustId, kassaId, amount, tip);
      final response = await service.newTransfer(dbId, dto);
      if (response['message'] == 'Ok') {
        fetchTransfers();
        selectTransfer(response['id']);
        Get.snackbar('Success', 'Yeni transfer ugurla yadda saxlanildi!');
      }

      // Update local list if needed
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateTransfer(TransferRequest dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('transferUpdate.... ${dto.toJson()}');

      final response = await service.updateTransfer(dbId, dto);
      switch (response['message']) {
        case 0:
          await fetchTransfers();
          Future.delayed(Duration(milliseconds: 100), () {
            selectTransfer(dto.id!);
            update(); // force UI update
          });
          // selectTransfer(dto.id!);
          Get.snackbar('Success', 'Ugurla yadda saxlanildi!');
          break;
        case 1:
          Get.snackbar('Warning', 'Emeliyyat basqasisinindir');
          break;
        case 2:
          Get.snackbar('Warning', 'Emeliyyat baglidir');
          break;
        case 3:
          Get.snackbar('Warning', 'Tarix kecib');
          break;
        case 4:
          Get.snackbar('Warning', 'Valyulatar ferqlidir');
          break;
        default:
          Get.snackbar('Info', 'Unknown response message.');
      }
      // Update local list if needed
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
