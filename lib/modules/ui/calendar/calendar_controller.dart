import 'package:get/get.dart';
import 'package:host_babminton/core/database_service.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:host_babminton/data/models/attendance.dart';
class CalendarController extends GetxController {
  var selectedTab = 0.obs;

  final upcomingSessions = <Map<String, dynamic>>[].obs;
  final pastSessions = <Map<String, dynamic>>[].obs;

  late Isar db;

  @override
  void onInit() {
    super.onInit();
    initDB();
  }

  Future<void> initDB() async {
    db = await Get.find<DatabaseService>().db;
    await loadSessions();
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  Future<void> loadSessions() async {
    final allSessions = await db.sessions.where().sortByDateDesc().findAll();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final upcomingList = <Session>[];
    final pastList = <Session>[];

    for (var session in allSessions) {
      final sessionDate = DateTime(
        session.date.year,
        session.date.month,
        session.date.day,
      );
      if (sessionDate.isAfter(today) || sessionDate.isAtSameMomentAs(today)) {
        upcomingList.add(session);
      } else {
        pastList.add(session);
      }
    }

    upcomingSessions.value = await _groupSessionsByMonth(upcomingList);
    pastSessions.value = await _groupSessionsByMonth(pastList);
  }

  Future<List<Map<String, dynamic>>> _groupSessionsByMonth(List<Session> sessions) async {
    if (sessions.isEmpty) return [];

    final grouped = <String, List<Map<String, dynamic>>>{};

    for (var session in sessions) {
      final monthKey = 'Tháng ${session.date.month}, ${session.date.year}';

      int weekday = session.date.weekday;
      String weekdayStr = weekday == 7 ? 'CN' : 'T${weekday + 1}';
      String dayStr = DateFormat('dd').format(session.date);

      String title =
          'Cầu lông $weekdayStr ${DateFormat('dd/MM').format(session.date)}';
      String timeStr = '${session.startTime} - ${session.endTime}';

      String statusStr = 'Nháp';
      if (session.status == SessionStatus.checkout) statusStr = 'Quyết toán';
      if (session.status == SessionStatus.closed) statusStr = 'Đã chốt';

      final attendanceCount = await db.attendances.filter().session((q) => q.idEqualTo(session.id)).count();

      final item = {
        'id': session.id,
        'weekday': weekdayStr,
        'day': dayStr,
        'title': title,
        'time': timeStr,
        'venue': session.venue.value?.name ?? 'Chưa rõ sân',
        'status': statusStr,
        'attendance': '$attendanceCount/${session.maxPlayers}',
      };

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(item);
    }

    return grouped.entries
        .map((e) => {'month': e.key, 'items': e.value})
        .toList();
  }

  // Called when a new session is added to trigger a reload
  Future<void> reloadData() async {
    await loadSessions();
  }
}
