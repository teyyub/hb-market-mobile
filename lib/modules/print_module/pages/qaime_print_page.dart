import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/print_module/controller/qaime_print_controller.dart';
import '../models/qaime_detail_dto.dart';
import '../models/qaime_item.dart';

class QaimePrintPage extends StatelessWidget {


  final QaimePrintController controller = Get.find<QaimePrintController>();

  @override
  Widget build(BuildContext context) {
    // Controller-dən məlumatları yükləyirik
    controller.loadQaime(170220);

    return Scaffold(
      appBar: AppBar(title: Text("Qaimə Detalları")),
      body: GetBuilder<QaimePrintController>(
        builder: (_) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage));
          }

          if (controller.qaimePrintDto == null) {
            return Center(child: Text("Məlumat tapılmadı"));
          }

          final QaimeDetailDto? qaimeDetail = controller.qaimePrintDto?.qaimeDetail!;
          final List<QaimeItem>? qaimeItems = controller.qaimePrintDto?.qaimeItems;

          final htmlContent = """
            <h2>Qaimə #${qaimeDetail?.id}</h2>
            <p>Müştəri: ${qaimeDetail?.dtAd}</p>
            <p>Obyekt: ${qaimeDetail?.oAd}</p>
            <p>Məbləğ: ${qaimeDetail?.mebleg}</p>
            <p>Rəsmiləşdirilmiş məbləğ: ${qaimeDetail?.rmeb}</p>
            <p>Ödənilən: ${qaimeDetail?.oden}</p>
            <p>Endirim: ${qaimeDetail?.endirim}%</p>
            <h3>Məhsullar</h3>
            <table border="1" cellpadding="4" cellspacing="0">
              <tr>
                <th>Ad</th><th>Barkod</th><th>Miqdar</th><th>Qiymət</th><th>Məbləğ</th>
              </tr>
              ${qaimeItems?.map((item) => """
                <tr>
                  <td>${item.ad}</td>
                  <td>${item.barkod}</td>
                  <td>${item.miqdar}</td>
                  <td>${item.qiymet}</td>
                  <td>${item.mebleg}</td>
                </tr>
              """).join()}
            </table>
          """;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Html(data: htmlContent),
          );
        },
      ),
    );
  }
}
