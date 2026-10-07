import 'package:isar/isar.dart';
import 'session.dart';
import 'member.dart';

part 'attendance.g.dart';

enum AttendanceStatus { notVoted, present, absent }

enum PaymentStatus { unpaid, paid }

// Lượt điểm danh
@collection
class Attendance {
  Id id = Isar.autoIncrement;

  final session = IsarLink<Session>();
  final member = IsarLink<Member>();

  String guestName;
  bool isMale;

  @enumerated
  AttendanceStatus attendanceStatus;

  @enumerated
  PaymentStatus paymentStatus;

  int feeToPay;

  Attendance({
    this.guestName = '',
    required this.isMale,
    this.attendanceStatus = AttendanceStatus.notVoted,
    this.paymentStatus = PaymentStatus.unpaid,
    this.feeToPay = 0,
  });
}
