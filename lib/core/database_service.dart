import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:host_babminton/data/models/venue.dart';
import 'package:host_babminton/data/models/member.dart';
import 'package:host_babminton/data/models/session.dart';
import 'package:host_babminton/data/models/invoice.dart';
import 'package:host_babminton/data/models/extra_fee.dart';
import 'package:host_babminton/data/models/attendance.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          VenueSchema,
          MemberSchema,
          SessionSchema,
          InvoiceSchema,
          ExtraFeeSchema,
          AttendanceSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
