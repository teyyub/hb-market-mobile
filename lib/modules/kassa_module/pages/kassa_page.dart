import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';

import 'package:hbmarket/modules/common/widgets/custom_table.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/customer_module/controller/customer_controller.dart';
import 'package:hbmarket/modules/customer_module/pages/customer_detail_page.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/kassa_module/widgets/FilterKassa.dart';
import 'package:trina_grid/trina_grid.dart';

class KassaPage extends StatelessWidget {
  final KassaController controller = Get.find<KassaController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Kassalar'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<KassaController>(
                  builder: (KassaController ctrl) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // return _buildTable2(ctrl);
                    return _buildTrinaGrid(ctrl);
                    // return kIsWeb
                    //     ? _buildTable2(ctrl)
                    //     : _buildGridView(ctrl, context);
                  },
                ),
              ),
            ],
          ),
          // child: GetBuilder<CustomerController>(
          //   builder: (ctrl) {
          //     return kIsWeb ? _buildListView(ctrl) : _buildGridView(ctrl);
          //   },
          // ),
        ),
      ),
    );
  }

  Widget _buildTable2(KassaController ctrl) {
    return CustomDataTable<Kassa>(
      data: ctrl.kassa,
      sortColumnIndex: ctrl.sortColumnIndex,
      sortAscending: ctrl.sortAscending,
      // columnSpacing: 12,
      // horizontalMargin: 12,
      // isHorizontalScrollBarVisible: true,
      // isVerticalScrollBarVisible: true,
      // minWidth: 600,
      columns: [
        DataColumn2(
          label: Text('No'),
          onSort: (colIndex, asc) => ctrl.sort<num>((k) => k.id, colIndex, asc),
        ),
        DataColumn2(
          label: Text('Ad'),
          onSort: (colIndex, asc) =>
              ctrl.sort<String>((k) => k.ad, colIndex, asc),
        ),
        DataColumn2(label: Text('Pul')),
        DataColumn2(label: Text('Aktiv')),
      ],
      rowBuilder: (data) {
        return data.map((k) {
          return DataRow(
            cells: [
              DataCell(Text(k.id.toString())),
              DataCell(Text(k.ad)),
              DataCell(Text(k.money.toString())),
              DataCell(Text(k.aktiv!)),
            ],
          );
        }).toList();
      },
    );
  }
  // custom ile evez edirem
  // Widget _buildTable2(KassaController ctrl) {
  //   return DataTable2(
  //     sortColumnIndex: ctrl.sortColumnIndex,
  //     sortAscending: ctrl.sortAscending,
  //     columnSpacing: 12,
  //     horizontalMargin: 12,
  //     // headingRowColor: WidgetStateColor.resolveWith(
  //     //   (states) => Colors.grey[850]!,
  //     // ),
  //     // headingTextStyle: const TextStyle(color: Colors.white),
  //     // headingCheckboxTheme: const CheckboxThemeData(
  //     //   side: BorderSide(color: Colors.white, width: 2.0),
  //     // ),
  //     //checkboxAlignment: Alignment.topLeft,
  //     isHorizontalScrollBarVisible: true,
  //     isVerticalScrollBarVisible: true,
  //     // minWidth: 600,
  //     columns: [
  //       DataColumn2(
  //         label: Text('No'),
  //         onSort: (colIndex, asc) => ctrl.sort<num>((k) => k.id, colIndex, asc),
  //       ),
  //       DataColumn(
  //         label: Text('Ad'),
  //         onSort: (colIndex, asc) =>
  //             ctrl.sort<String>((k) => k.ad, colIndex, asc),
  //       ),
  //       DataColumn(label: Text('Aktiv')),
  //     ],
  //     rows: ctrl.kassa.map((k) {
  //       return DataRow(
  //         cells: [
  //           DataCell(Text(k.id.toString())),
  //           DataCell(Text(k.ad)),
  //           DataCell(Text(k.aktiv)),
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search'.tr,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_alt), // filter icon
          onPressed: () {
            // Optional: open filter dialog / additional filter options
            print("Filter icon tapped");
          },
        ),
      ),
      onChanged: (value) {
        controller.setSearchQuery(value); // Filter logic in controller
      },
    );
  }

  Widget _buildProcedureButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        await controller.runProcedure();
      },

      icon: const Icon(Icons.play_arrow),
      label: const Text('Run Procedure'),
    );
  }

  Widget _buildListView1(KassaController ctrl) {
    return ListView.separated(
      // shrinkWrap: true,
      // physics:
      //     const NeverScrollableScrollPhysics(), // prevent conflict with parent scroll
      itemCount: ctrl.kassa.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final k = ctrl.kassa[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(k.id.toString()), // Show ID in circle
          ),
          title: Text(k.ad),
          subtitle: Text("aktiv: ${k.aktiv}"),
          trailing: const Icon(Icons.chevron_right),

          onTap: () {
            // Handle tap on row
            print("Tapped on ${k.ad}");
          },
        );
      },
    );
  }

  Widget _buildListView(KassaController ctrl) {
    return ListView.separated(
      // padding: EdgeInsets.all(16),
      itemCount: ctrl.kassa.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        // if (index >= controller.filteredCustomers.length) {
        //   return const SizedBox(); // boş widget qaytar
        // }
        final customer = ctrl.kassa[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(customer.ad[0])),
            title: Text(customer.ad),
            subtitle: Text(customer.ad.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(KassaController ctrl, BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    double childAspectRatio = MediaQuery.of(context).size.width > 600 ? 2 : 1.3;
    return GridView.builder(
      // padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: controller.kassa.length,
      itemBuilder: (context, index) {
        // if (index >= controller.filteredCustomers.length) {
        //   return const SizedBox(); // boş widget qaytar
        // }
        final customer = controller.kassa[index];
        return InkWell(
          onTap: () {
            // Navigate to detail page
            // Get.to(() => CustomerDetailPage(customer: customer));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width > 600 ? 40 : 30,
                    child: Text(customer.ad),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      customer.ad,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 18
                            : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      customer.ad,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 16
                            : 12,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ); // return Card(
        //   child: Center(
        //     child: ListTile(
        //       leading: CircleAvatar(child: Text(customer.name[0])),
        //       title: Text(customer.name),
        //       subtitle: Text(customer.email),
        //     ),
        //   ),
        // );
      },
    );
  }

  Widget _buildDataTable(KassaController ctrl) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // in case too many columns
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => Colors.grey[200]!,
        ),
        border: TableBorder.all(color: Colors.grey.shade300, width: 1),
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Ad')),
        ],
        rows: ctrl.kassa.map((k) {
          return DataRow(
            cells: [DataCell(Text(k.id.toString())), DataCell(Text(k.ad))],
          );
        }).toList(),
      ),
    );
  }
}

class _SortIcon extends StatelessWidget {
  final bool ascending;
  final bool active;

  const _SortIcon({required this.ascending, required this.active});

  @override
  Widget build(BuildContext context) {
    return Icon(
      ascending ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
      size: 28,
      color: active ? Colors.cyan : null,
    );
  }
}

Widget _buildTrinaGrid(KassaController ctrl) {
  // Map<String, double> savedColumnWidths = {};
  final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();
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
          IconButton(
            icon: const Icon(Icons.filter_list), // Filter ikonu
            tooltip: 'Filterlər'.tr, // Tooltip əlavə edirik
            onPressed: () async {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Başlıq və close düyməsi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Sənin FilterKassa widget-ın burada yerləşəcək
                      FilterKassa(
                        onSave: (String? name, String? aktiv) {
                          ctrl.applyFilter(name);
                          // ctrl.fetchKassa(nameFilter: name);
                          // Get.back(); // bottom sheet-i bağlayır
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent, // artıq Container rəngini istifadə edirik
              );


            },
          ),
          // const SizedBox(width: 8),
          if (ctrl.isFiltered)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Sıfırla',
              onPressed: () => ctrl.resetFilter(),

            ),
          const SizedBox(width: 8), // İkonlar arasında bir az boşluq
          ColumnVisibilityMenu(
            columns: ctrl.columns,
            onChanged: (String key, bool visible) =>
                ctrl.toggleColumnVisibilityExplicit(key, visible),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Expanded(
        child: TrinaGridWidget<Kassa>(
          key: ValueKey(ctrl.columns.map((c) => c['visible']).join()),
          data: ctrl.kassa,
          selectedId: ctrl.selectedId,
          // onSelect: ctrl.selectPartnyor,
          onSelect: (item) {
            ctrl.setSelectedKassa(item); // works even if ID column is hidden
          },
          onColumnVisibilityChanged: (key, visible) {
            ctrl.toggleColumnVisibilityExplicit(key, visible);
          },
          getId: (p) => p.id,
          columns: displayColumns,
          cellBuilder: (p) {
            final Map<String, TrinaCell> cells = {};

            // cells['id'] = TrinaCell(value: p.id.toString());
            for (final c in displayColumns) {
              switch (c['key']) {
                case 'id':
                  cells['id'] = TrinaCell(value: p.id.toString());
                  break;
                case 'name':
                  cells['name'] = TrinaCell(value: p.ad);
                  break;
                case 'money':
                  cells['money'] = TrinaCell(value: p.money);
                  break;
                case 'active':
                  cells['active'] = TrinaCell(value: p.aktiv);
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
