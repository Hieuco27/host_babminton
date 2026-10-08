import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:host_babminton/core/database_service.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/invoice.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
import 'package:host_babminton/data/models/attendance.dart';

class FinanceSessionItem {
  final Session session;
  final Invoice invoice;
  final int totalCost;
  final int totalExtras;
  final int totalPresent;
  final int presentMales;
  final int presentFemales;
  final int totalCollected;
  final int debtCount;

  FinanceSessionItem({
    required this.session,
    required this.invoice,
    required this.totalCost,
    required this.totalExtras,
    required this.totalPresent,
    required this.presentMales,
    required this.presentFemales,
    required this.totalCollected,
    required this.debtCount,
  });
}

class FinanceController extends GetxController {
  final DatabaseService _dbService = Get.find<DatabaseService>();

  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final RxList<FinanceSessionItem> sessionItems = <FinanceSessionItem>[].obs;
  
  final RxInt totalCost = 0.obs;
  final RxInt totalCollected = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    debounce(searchQuery, (_) => filterData(), time: const Duration(milliseconds: 300));
  }

  void changeMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    loadData();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    updateSearchQuery('');
  }

  List<FinanceSessionItem> _allItems = [];

  Future<void> loadData() async {
    final isar = await _dbService.db;
    
    final startOfMonth = DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
    final endOfMonth = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0, 23, 59, 59);

    final sessions = await isar.sessions
        .filter()
        .dateBetween(startOfMonth, endOfMonth)
        .anyOf(
          [SessionStatus.checkout, SessionStatus.closed],
          (q, status) => q.statusEqualTo(status),
        )
        .sortByDateDesc()
        .findAll();

    int sumCost = 0;
    int sumCollected = 0;
    List<FinanceSessionItem> items = [];

    for (var session in sessions) {
      await session.venue.load();
      
      final invoice = await isar.invoices.filter().session((q) => q.idEqualTo(session.id)).findFirst();
      if (invoice == null) continue;

      final extraFees = await isar.extraFees.filter().session((q) => q.idEqualTo(session.id)).findAll();
      final attendances = await isar.attendances.filter().session((q) => q.idEqualTo(session.id)).findAll();

      int tExtras = extraFees.fold(0, (sum, item) => sum + item.amount);
      int tCost = invoice.courtFee + (invoice.shuttlecockPrice * invoice.shuttlecockCount) + tExtras;

      int pMales = 0;
      int pFemales = 0;
      int tCollected = 0;
      int dCount = 0;

      for (var a in attendances) {
        if (a.attendanceStatus == AttendanceStatus.present) {
          if (a.isMale) pMales++; else pFemales++;
          if (a.paymentStatus == PaymentStatus.paid) {
            tCollected += a.feeToPay;
          } else {
            dCount++;
          }
        }
      }

      sumCost += tCost;
      sumCollected += tCollected;

      items.add(FinanceSessionItem(
        session: session,
        invoice: invoice,
        totalCost: tCost,
        totalExtras: tExtras,
        totalPresent: pMales + pFemales,
        presentMales: pMales,
        presentFemales: pFemales,
        totalCollected: tCollected,
        debtCount: dCount,
      ));
    }

    totalCost.value = sumCost;
    totalCollected.value = sumCollected;
    _allItems = items;
    filterData();
  }

  String _removeDiacritics(String str) {
    var withDia = 'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    var withoutDia = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
      str = str.replaceAll(withDia[i].toUpperCase(), withoutDia[i].toUpperCase());
    }
    return str;
  }

  void filterData() {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      sessionItems.value = _allItems;
    } else {
      final normQuery = _removeDiacritics(query);
      
      sessionItems.value = _allItems.where((item) {
        final venueName = item.session.venue.value?.name ?? '';
        return _removeDiacritics(venueName.toLowerCase()).contains(normQuery);
      }).toList();
    }
  }
}
