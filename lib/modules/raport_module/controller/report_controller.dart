import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/kassa_module/data/fake_kassa_list.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';

import 'package:hbmarket/modules/raport_module/models/report_grouped_print.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_print.dart';
import 'package:hbmarket/modules/raport_module/service/report_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hbmarket/modules/raport_module/common/export_html.dart';

class ReportController extends GetxController {
  // final ObyektController obyController = Get.put(ObyektController());
  final ObyektController obyController = Get.find<ObyektController>();
  List<Report> reports = [];
  List<Report> reports1 = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  Report? selectedReport;
  List<ReportPrintGroup> reportItems = [];
  bool reportItemFetched = false;

  bool get reportsFetched => reportItems.isNotEmpty;

  late final ReportService service;

  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  void setSelectedReport(Report report) {
    selectedReport = report;
    // print('${selectedReport}');
    update();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    update();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    service = ReportService(client: ApiClient());
    fetchReports();
  }

  void fetchReportPrint() async {
    // final selected = obyController.selectedObyekt;
    print('2');
    isLoading = true;
    update(); // show loading spinner

    int dbKey = DbSelectionController.to.dbId;
    int reportId = selectedReport!.id;
    int objectId = obyController.selectedObyekt!.id;
    try {
      // reportItems = await service.fetchReportPrint(
      //   dbKey,
      //   reportId,
      //   objectId,
      //   startDate,
      //   endDate,
      // );
      String html = await service.fetchReportPrintV1(
        dbKey,
        reportId,
        objectId,
        startDate,
        endDate,
      );
      await openHtmlInBrowser(html);
      print('html:${html}');
      // final Uri uri = Uri.dataFromString(
      //   html,
      //   mimeType: 'text/html',
      //   encoding: Encoding.getByName('utf-8'),
      // );

      // if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      //   print('Could not launch report in browser');
      // }
      // print('reportItems ${reportItems}');
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      // reportItemFetched = true;
      isLoading = false;
      update(); // rebuild UI
    }
  }

  Future<void> openHtmlInBrowser(String htmlContent) async {
    if (kIsWeb) {
      openHtmlInNewTab(htmlContent);
    } else {
      _openHtmlInMobileBrowserV1(htmlContent);
    }
  }

  /// Mobile-only helper to open HTML in the browser
  Future<void> _openHtmlInMobileBrowser(String htmlContent) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/report.html');
    await file.writeAsString(htmlContent, encoding: utf8);

    // final Uri uri = Uri.dataFromString(
    //   htmlContent,
    //   mimeType: 'text/html',
    //   encoding: utf8,
    // );
    final Uri uri = Uri.file(file.path);
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showErrorMessage('Could not open the report in browser.');
      }
    } catch (e) {
      _showErrorMessage('Error opening report: $e');
    }
  }

  Future<void> _openHtmlInMobileBrowserV1(String htmlContent) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final htmlFile = File('${tempDir.path}/report.html');
      await htmlFile.writeAsString(htmlContent, encoding: utf8);

      // Start a local HTTP server
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((HttpRequest request) async {
        final fileBytes = await htmlFile.readAsBytes();
        request.response.headers.contentType = ContentType.html;
        request.response.add(fileBytes);
        await request.response.close();
      });

      final url = 'http://${server.address.address}:${server.port}/';
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        _showErrorMessage('Could not open report in browser.');
      }

      // Automatically close server after 10 seconds
      Future.delayed(Duration(seconds: 10), () {
        server.close(force: true);
      });
    } catch (e) {
      _showErrorMessage('Error opening report: $e');
    }
  }

  /// Show a user-friendly error message using GetX snackbar
  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> fetchReports() async {
    try {
      print(
        'DbSelectionController.to.selectedDb..${DbSelectionController.to.getDbId}',
      );
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dbId->${dbId}');
      reports = await service.fetchReports(dbId);
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  List<Report> get filteredReports {
    if (searchQuery.isEmpty) return reports;
    return reports
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // void addCustomer(Kassa customer) {
  //   customers.add(customer);
  //   update();
  // }

  // void removeCustomer(Kassa k) {
  //   customers.remove(k);
  //   update();
  // }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }
}
