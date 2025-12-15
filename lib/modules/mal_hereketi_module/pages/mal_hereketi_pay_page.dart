import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/mal_odenis_dto.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/odenis_request.dart';
import 'package:hbmarket/modules/mal_hereketi_module/widgets/pay_oper_widget.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../kassa_module/controller/kassa_controller.dart';
import '../../xerc_qazanc_module/widget/yeni_xerc.dart';
import '../controller/mal_hereketi_controller.dart';
import '../models/pul_hereketi_bax.dart';

class MalHereketiPayPage extends StatelessWidget {
  // final ObyektController obyController = Get.find<ObyektController>();
  final MalHereketiController malHereketiController = Get.find<MalHereketiController>();
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: '${malHereketiController.selectedMalHereketiDto?.id} nömrəli hərəkət planı',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // _buildTopControls(context),
              // const SizedBox(height: 16),

              Flexible(
                child: GetBuilder<MalHereketiController>(
                  builder: (MalHereketiController ctrl) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // return _buildTable();
                    return _buildTrinaGrid(ctrl,context);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text("Yeni".tr),
                  onPressed: ()  {
                    // malHereketiController.fetchMalHereketBax();
                    // Get.to(() =>PayOperPage());
                    _openBottomSheet();
                  },
                ),
                const SizedBox(width: 12,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: Text("Redaktə".tr),
                  onPressed: ()  {
                    OdenisRequestDto editMalOdenis = OdenisRequestDto(
                        pulal: malHereketiController.selectedMalOdenisDto!.id,
                        qdaxil:malHereketiController.selectedMalHereketiDto!.id,
                        mebleg: malHereketiController.selectedMalOdenisDto!.mebleg,
                        kassaId: malHereketiController.selectedMalOdenisDto!.kassa.id
                    );
                     _openBottomSheet(editDto: editMalOdenis);
                  },
                ),
              ],)
            ],

          ),
        ),
      ),
    );
  }



  Widget _buildTrinaGrid(MalHereketiController ctrl , BuildContext context) {
    // Map<String, double> savedColumnWidths = {};

    final visibleColumns = ctrl.malOdenisleriColumns.where((c) => c['visible']).toList();

    debugPrint('${visibleColumns}');
    final displayColumns = visibleColumns.isNotEmpty
        ? visibleColumns
        : [
            {'key': 'placeholder', 'label': 'Bosdur', 'visible': true},
          ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (String key, bool visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Expanded(
          child: TrinaGridWidget<MalOdenisDto>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.malOdenisleri,
            selectedId: ctrl.selectedId,
            // onSelect: ctrl.selectPartnyor,
            onSelect: (MalOdenisDto item) {
              ctrl.setSelectedMalOdenis(
                item,
              ); // works even if ID column is hidden
            },

            getId: (p) => p.id,
            columns: displayColumns,
            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};
              for (final Map<String, dynamic> c in displayColumns) {
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'mebleg':
                    cells['mebleg'] = TrinaCell(value: p.mebleg);
                    break;
                  case 'kad':
                    cells['kad'] = TrinaCell(value: p.kassa.ad);
                    break;

                  default:
                    cells[c['key']] = TrinaCell(value: '');
                }
              }

              return cells;
            },
          ),
        ),
      ],
    );
  }

  void _openBottomSheet({OdenisRequestDto? editDto }) async {
    final kassaCtrl = Get.find<KassaController>();
    kassaCtrl.resetSelections();
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await kassaCtrl.preloadData();
    Get.back();
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4, // start at 70% of screen
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController, // attach scrollController!
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yeni pul al'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PayOperWidget(
                      onSave: (OdenisRequestDto dto) async {
                         debugPrint('odenis: ${dto.toJson()}');
                       final result =  await malHereketiController.yeniOdenis(dto);
                         if (!result.success) {
                           Get.snackbar("Xəta", result.message);
                           return;
                         }
                         malHereketiController.fetchMalOdenisi();
                        // Get.back();
                      },
                    initialDto:  editDto,
                    qdaxil: malHereketiController.selectedMalHereketiDto!.id,
                    pulal: 0,
                  )
                  // YeniXercDialog(
                  //   mustId: controller.selectedMustId!,
                  //   initial: XercRequestDto(
                  //     mustId: controller.selectedMustId ?? 0,
                  //     kassaId: 0,
                  //     amount: null,
                  //     pays: null,
                  //     sign: '',
                  //     categoryId: null,
                  //     subCategoryId: null,
                  //     sebeb: '',
                  //     qeyd: '',
                  //   ),
                  //   onSave: (XercRequestDto dto) async {
                  //     await controller.saveYeniXerc(dto);
                  //     Get.back();
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // optional
    );
  }
}
