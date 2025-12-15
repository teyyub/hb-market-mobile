import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table2.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/mal_hereketi.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/widgets/add_barcode.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';
import 'package:hbmarket/modules/object_module/widget/select_object_button.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../hereket_module/models/hereket_request.dart';
import '../../hereket_module/widget/work_widget_bkp1.dart';
import '../controller/mal_hereketi_controller.dart';
import 'mal_hereketi_bax_page.dart';
import 'mal_hereketi_pay_page.dart';

class MalHereketiPage extends StatelessWidget {
  // final ObyektController obyController = Get.find<ObyektController>();
  final MalHereketiController malHereketiController = Get.find<MalHereketiController>();
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Mal hərəkəti',
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
                  icon: const Icon(Icons.content_paste_search),
                  label: Text("Bax".tr),
                  onPressed: ()  {
                    if (malHereketiController.malHereketleri.isEmpty) {
                      Get.snackbar(
                        "Məlumat yoxdur",
                        "Bu hərəkətləri üçün qaimə tapılmadı",
                      );
                      return;
                    }
                    malHereketiController.fetchMalHereketBax();
                    Get.to(() => MalHereketiBaxPage());
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: Text("Ödənişlər".tr),
                  onPressed: ()  {
                    if (malHereketiController.malHereketleri.isEmpty) {
                      Get.snackbar(
                        "Məlumat yoxdur",
                        "Bu hərəkət üçün ödəniş tapılmadı",
                      );
                      return;
                    }
                    malHereketiController.fetchMalOdenisi();
                    Get.to(() => MalHereketiPayPage());
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

    final visibleColumns = ctrl.malHereketiColumns.where((c) => c['visible']).toList();

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
          child: TrinaGridWidget<MalHereketiDto>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.malHereketleri,
            selectedId: ctrl.selectedId,
            // onSelect: ctrl.selectPartnyor,
            onSelect: (MalHereketiDto item) {
              ctrl.setSelectedMalHereketi(
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
                  case 'gfaiz':
                    cells['gfaiz'] = TrinaCell(value: p.gfaiz);
                    break;
                  case 'meblegN2':
                    cells['meblegN2'] = TrinaCell(value: p.meblegN2);
                    break;
                  case 'rmeb':
                    cells['rmeb'] = TrinaCell(value: p.rMeb);
                    break;
                  case 'oden':
                    cells['oden'] = TrinaCell(value: p.oden);
                    break;
                  case 'mad':
                    cells['mad'] = TrinaCell(value: p.mAd);
                    break;
                  case 'dtAd':
                    cells['dtAd'] = TrinaCell(value: p.dtAd);
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
}
