import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/hereket_module/controller/qaime_bax_controller.dart';
import 'package:hbmarket/modules/hereket_module/models/qaime_bax.dart';
import 'package:hbmarket/modules/hereket_module/widget/qaime_redakte_widget.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../main_page.dart';
import '../../common/widgets/column_visibility_menu.dart';
import '../../common/widgets/trina_grid_widget.dart';

class QaimeBaxPage extends StatefulWidget {
  final int dplanId;
  const QaimeBaxPage({super.key, required this.dplanId});

  @override
  State<QaimeBaxPage> createState() => _QaimeBaxPageState();
}

class _QaimeBaxPageState extends State<QaimeBaxPage> {
  QaimeBaxController qaimeCtrl = Get.find<QaimeBaxController>();

  @override
  void initState() {
    super.initState();
    qaimeCtrl.qaimeBax(widget.dplanId); // səhifə açılarkən çağırılır
  }


  @override
  Widget build(BuildContext context) {
    return MainLayout(
        title: 'Qaimə Bax'.tr,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GetBuilder<QaimeBaxController>(
                builder: (QaimeBaxController ctrl) {
                  if (ctrl.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Card(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return SizedBox(
                                width: constraints.maxWidth,
                                height:
                                constraints.maxHeight, // ensures bounded height
                                child: _buildTrinaGrid(ctrl),
                                // child: _buildTable2(ctrl),
                              );
                            },
                          ),
                        ),
                      ),

                      Row(
                        children: [

                          // Expanded(
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //
                          //     },
                          //     child: const Text('Bax'),
                          //   ),
                          // ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // final dto = QaimeBaxDto(
                                //   amount: int.tryParse(amountController.text),
                                //   price: double.tryParse(rQiymetCtrl.text),
                                //   sellPrice: double.tryParse(rQiymetCtrl.text),
                                // );
                                Get.bottomSheet<QaimeBaxDto>(
                                  QaimeRedakteWidget(requestDto: ctrl.getSelectedQaimeBax!),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                ).then((QaimeBaxDto? dtoSave) {
                                  if (dtoSave != null) {
                                    // final updatedDto = dtoSave.copyWith(
                                    //   dPlanId: widget.dPlanId,
                                    //   hereketId: widget.hereketId,
                                    //   note: noteController.text, // burda yeni note verirsən
                                    //   amount: dtoSave.amount,
                                    //   price: dtoSave.price,
                                    //   sellPrice: dtoSave.sellPrice,
                                    // );

                                    debugPrint('Updated DTO: ${dtoSave.toJson()}');
                                    // debugPrint('Returned dtoSave: $dtoSave');
                                    ctrl.qaimeBaxRedakte(dtoSave);
                                    // ctrl.setQaimeBaxDto = dtoSave;
                                  }
                                });
                              },
                              child: const Text('Redaktə'),
                            ),
                          ),

                        ],
                      ),
                    ],
                  );
                },
              ),
            )
        )
    );
  }

  Widget _buildTrinaGrid(QaimeBaxController ctrl) {
    // Map<String, double> savedColumnWidths = {};

    final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();

    // debugPrint('${visibleColumns.length}');
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
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (String key, bool visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Expanded(
          child: TrinaGridWidget<QaimeBaxDto>(
            key: ValueKey('${ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()}'),
            data: ctrl.qaimeBaxList,
            selectedId: ctrl.dPlanId,
            onSelect: (QaimeBaxDto item) {
              ctrl.setQaimeBaxDto = item; // works even if ID column is hidden
            },

            getId: (p) => p.id,
            columns: displayColumns,
            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};

              for (final Map<String, dynamic> c in displayColumns) {
                // debugPrint(c['key']);
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'ad':
                    cells['ad'] = TrinaCell(value: p.ad);
                    break;
                  case 'barkod':
                    cells['barkod'] = TrinaCell(value: p.barkod);
                    break;
                  case 'miqdar':
                    cells['miqdar'] = TrinaCell(value: p.miqdar);
                    break;
                  case 'qiymet':
                    cells['qiymet'] = TrinaCell(value: p.qiymet);
                    break;
                  case 'note':
                    cells['note'] = TrinaCell(value: p.qeyd);
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
